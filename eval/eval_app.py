import ConfigParser
import argparse
import logging
import time
import datetime
import sys
import os
import subprocess
import signal


def readConfigFile(config_file):
    try:
        config_parser = ConfigParser.RawConfigParser()
        return config_parser if config_parser.read(config_file) else None

    except ConfigParser.MissingSectionHeaderError as e:
        logging.error(str(e))
    except ConfigParser.ParsingError as e:
        logging.error(str(e))
    except ConfigParser.Error as e:
        logging.critical(str(e))


def getConfigSections(config_parser, section):
    config_dic = {}
    options = config_parser.options(section)
    for option in options:
        try:
            config_dic[option] = config_parser.get(section, option)
            if config_dic[option] == -1:
                logging.error("skip: %s" % option)
        except:
            logging.error("exception on %s!" % option)
            config_dic[option] = None
    return config_dic


def getConfigFullPath(config_file):
    try:
        with open(config_file) as f:
            pass
    except IOError as e:
        logging.warning("'%s' does not exist" % config_file)
        return None
    return os.path.abspath(config_file)


def getTimeStamp():
    try:
        ts = time.time()
        st = datetime.datetime.fromtimestamp(ts).strftime('%d-%H-%M')
    except:
        logging.warning("could not get time stamp")
        return None
    return st.replace("\n", "")

def ssh_remote_subprocess(recv_command, server_user, server_ip, seconds=1):
    subprocess.Popen("ssh " + server_user + "@" + server_ip + " " + recv_command, shell=True)
    time.sleep(seconds)

def ssh_remote_execute(recv_command, server_user, server_ip, seconds=1):
    os.system("ssh " + server_user + "@" + server_ip + " nohup echo "+recv_command+" >1 &")
    if "mg-server" in recv_command:
        command = "ssh " + server_user + "@" + server_ip + " \" cd /home/cheng/mongoose/"+ ";nohup ./mg-server -p 7003 &> out\""
        subprocess.Popen(command,shell=True)
        time.sleep(3)
        print(command)
    else:
        os.system("ssh " + server_user + "@" + server_ip + " nohup " + recv_command+"& " )
    time.sleep(seconds)


def ssh_kill(kill_command,server_user,server_ip):
    print(kill_command)
    os.system("ssh "+ server_user +"@"+server_ip +" "+ kill_command)
    time.sleep(1)
    os.system("exit")


def is_app_running(command):
    assert len(command) > 0
    return True if os.system(command) == 0 else False


def execute_benchmark():
        SERVERPATH = getConfigSections(local_config,"SERVER")['server_path']
        BENCHMARKPATH = getConfigSections(local_config,"BENCHMARK")['benchmark_path']

        PORT = getConfigSections(local_config, "SERVER")['port']
        SERVER_IP = getConfigSections(local_config, "SERVER")['server_ip']
        SERVER_USER = getConfigSections(local_config,"SERVER")['server_user']
        SERVER_PROGRAM = getConfigSections(local_config, "SERVER")['server_program']
        SERVER_CONF = getConfigSections(local_config, "SERVER")['server_conf']
        SERVER_KILL = getConfigSections(local_config, "SERVER")['server_kill']
        VALIDATE_APP_STATUS = getConfigSections(local_config, "SERVER")['validate_app_status']
        BENCHMARK_PROGRAM = getConfigSections(local_config, "BENCHMARK")['benchmark_program']
        BENCHMARK_CONF = getConfigSections(local_config, "BENCHMARK")['benchmark_conf']
        VALIDATE_BENCHMARK_STATUS = getConfigSections(local_config, "BENCHMARK")['validate_benchmark_status']
        REPORT_FILE = getConfigSections(local_config, "BENCHMARK")['report_file']

        get_rid_of_M = "sed -i "+"\"s/\\r/\\n/g\" "
        insert_command = "sed -i "+"\" 1 i command:   "+BENCHMARK_PROGRAM + " "+BENCHMARK_CONF+"\" "
        insert_server = "sed -i "+"\" 1 i server: "+SERVER_PROGRAM+"\" "

        report_file_name=SERVER_PROGRAM.split(' ')[-1]
        SERVER_PROGRAM = SERVERPATH + SERVER_PROGRAM

        BENCHMARK_PROGRAM = BENCHMARKPATH + BENCHMARK_PROGRAM
        LATEST_LINK= REPORT_FILE
        REPORT_FILE = REPORT_FILE + '_' + getTimeStamp()+"_"+str(config_file).split('/')[-1]
        ssh_kill(SERVER_KILL,SERVER_USER,SERVER_IP)
        run_server(VALIDATE_APP_STATUS,SERVER_IP,SERVER_USER, SERVER_KILL, SERVER_PROGRAM, SERVER_CONF)
        time.sleep(25)
        run_benchmark(REPORT_FILE, BENCHMARK_PROGRAM, BENCHMARK_CONF, VALIDATE_BENCHMARK_STATUS)
        comm = "cp /home/hkucs/qemu_output/latest_master_log "+REPORT_FILE.split('.')[0]+"_master.log"
	print(comm)
        os.system(comm)
        comm = "cp /home/hkucs/qemu_output/latest_slave_log "+REPORT_FILE.split('.')[0]+"_slave.log"
        os.system(comm)
        time.sleep(15)
        get_rid_of_M = get_rid_of_M + REPORT_FILE
        insert_server = insert_server + REPORT_FILE
        insert_command = insert_command + REPORT_FILE
        print("report: "+REPORT_FILE+" link: "+LATEST_LINK)
        latest_link = "ln -s " + REPORT_FILE+" "+LATEST_LINK
        rm_link = "rm -f "+ LATEST_LINK
       # kill_all_process(SERVER_PROGRAM)
        ssh_kill(SERVER_KILL,SERVER_USER,SERVER_IP)
        os.system(get_rid_of_M)
        os.system(insert_command)
        os.system(insert_server)
        os.system(rm_link)
        os.system(latest_link)
def run_server(status,server_ip, server_user,server_kill, server_program, server_conf, *args):
    # 3. ensure the previous app server is down
    try:
        #ssh_kill(server_kill,server_user.server_ip,1)
        if "ssdb" in server_program or "apache" in server_program:
            command = "sudo "+ server_program + " " + server_conf
            ssh_remote_execute(command,server_user,server_ip,4)
            os.system("exit")
           # app_proc = subprocess.Popen("sudo "+ server_program + " " + server_conf, shell=True)
        else:
            command = server_program + " " + server_conf
            ssh_remote_execute(command,server_user,server_ip,4)
            os.system("exit")
    except IOError as server_error:
    #    if app_pid:
     #       os.kill(app_pid, signal.SIGINT)
        print(server_error)

def run_benchmark(report, benchmark_server, benchmark_conf, command, *args):
    try:
        os.system("cat /dev/null > /home/hkucs/qemu_output/latest_master_log")
        os.system("cat /dev/null > /home/hkucs/qemu_output/latest_slave_log")
        if "sysbench" in benchmark_server:
            if "--pgsql-db=postgres" in benchmark_conf:
		benchmark_server ="LD_LIBRARY_PATH=\"/home/hkucs/my_ubuntu/benchmark/postgresql/install/lib/\" " + benchmark_server
		print(benchmark_server)
            prepare = benchmark_conf+" cleanup"
            os.system(benchmark_server+" "+prepare)
            time.sleep(5)
            prepare = benchmark_conf+" prepare"
            os.system(benchmark_server+" "+prepare)
            time.sleep(30)
            benchmark_conf = benchmark_conf+" run"
        if "ycsb" in benchmark_server:
            prepare = "load "+benchmark_conf
            os.system(benchmark_server+" "+prepare)
            time.sleep(30)
            benchmark_conf = "run "+benchmark_conf

        print("####################################################")
        print(benchmark_server + " "+benchmark_conf + " 1 >> " + report+" 2 >> "+report)
        os.system(benchmark_server + " "
                                          + benchmark_conf
                                          + " >> " + report )
        print("####################################################")

    except IOError as benchmark_error:
    #    if benchmark_proc.pid:
    #        os.kill(benchmark_proc.pid, signal.SIGINT)
        print(benchmark_error)

def kill_process(identifier):
    pid = os.popen("ps -ef | grep " + identifier + " | grep -v grep | awk '{print $2}'").read()

    if pid > 1:
        os.system("sudo kill -9 " + pid)

def kill_all_process(id):
        os.system("sudo killall -9 "+id)

def house_keeping(command, identifier):
    try:
        while is_app_running(command):
            time.sleep(10)

        kill_process(identifier)
        #kill_all_process(identifier)
    except:
        logging.error("app shutdown error")

if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(name)-s %(levelname)-s %(message)s',
                        datefmt='%m-%d %H:%M',
                        filename='/tmp/rdma4qemu-app.log',
                        filemode='w')
    # define a Handler which writes INFO messages or higher to the sys.stderr
    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)
    # set a format which is simpler for console use
    formatter = logging.Formatter('%(name)-s: %(levelname)-s %(message)s')
    # tell the handler to use this format
    console.setFormatter(formatter)
    # add the handler to the root logger
    logging.getLogger('').addHandler(console)
    logger = logging.getLogger()

    # Parse args and give some help how to handle this file
    parser = argparse.ArgumentParser(description='Apps Benchmark')
    parser.add_argument('--filename', '-f',
                        type=str,
                        help="include an app setting script")
    args = parser.parse_args()

    config_file = args.filename

    logging.info("processing '" + config_file + "'")
    full_path = getConfigFullPath(config_file)

    local_config = readConfigFile(full_path)

    # execute and record the benchmark output
    execute_benchmark()
