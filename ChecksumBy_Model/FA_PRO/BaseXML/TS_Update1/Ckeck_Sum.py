import os
import hashlib
import shutil
import time


def compute_checksum(file_path, algorithm='sha256'):
    """计算文件的校验和"""
    hash_func = hashlib.new(algorithm)
    with open(file_path, 'rb') as f:
        for chunk in iter(lambda: f.read(4096), b''):
            hash_func.update(chunk)
    return hash_func.hexdigest()


def get_files(directory, file_extensions):
    """获取目录下所有指定后缀的文件路径，不区分大小写"""
    file_list = []
    for root, _, files in os.walk(directory):
        for f in files:
            if any(f.lower().endswith(ext.lower()) for ext in file_extensions):
                file_list.append(os.path.join(root, f))
    return file_list


def main(server_directory, local_directory, file_extensions, algorithm='sha256'):
    """比对服务器目录和本地目录并同步文件"""
    log_file = "Check_sum_log.txt"
    with open(log_file, "a+") as log:
        start_time = time.time()  # 记录开始时间

        files_in_server = get_files(server_directory, file_extensions)

        for file_server in files_in_server:
            relative_path = os.path.relpath(file_server, server_directory)
            file_local = os.path.join(local_directory, relative_path)

            if os.path.exists(file_local):
                checksum_server = compute_checksum(file_server, algorithm)
                checksum_local = compute_checksum(file_local, algorithm)
                if checksum_server != checksum_local:
                    os.remove(file_local)
                    shutil.copy2(file_server, file_local)
                    log.write(f"File {file_local} updated with {file_server}\n")
                    print(f"File {file_local} updated with {file_server}")
            else:
                os.makedirs(os.path.dirname(file_local), exist_ok=True)
                shutil.copy2(file_server, file_local)
                log.write(f"File {file_local} copied from {file_server}\n")
                print(f"File {file_local} copied from {file_server}")

        end_time = time.time()  # 记录结束时间
        elapsed_time = end_time - start_time  # 计算耗时
        log.write(f"Start time: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(start_time))}\n")
        log.write(f"End time: {time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(end_time))}\n")
        log.write(f"Elapsed time: {elapsed_time:.2f} seconds\n")


if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("Usage: python Check_Sum.py <server_directory> <local_directory>")
    else:
        server_directory = sys.argv[1]
        local_directory = sys.argv[2]
        file_extensions = ['.bat', '.py', '.xml','.ini','.sed','.cmd','.sys','.ps1','.dll','.exe']  # 在这里定义文件后缀列表
        try:
            main(server_directory, local_directory, file_extensions)
        except Exception as mess:
            sys.exit(1)
