from scipy.io import savemat
import numpy as np
import zarr
import argparse
import os
import sys
import matplotlib.pyplot as plt

SECONDS_IN_HR = 3600
# Save large numpy file as a mat file.  Save smaller segments of the numpy file as mat file.


class TUM_npy2mat:
    def __init__(self, config):
        self.config = config

    def slice_accelerometer_data(self, data, offset_time, duration):
        rows, col = stationary_acclerometer_data.shape
        tot_time = stationary_acclerometer_data[-1,
                                                0] - stationary_acclerometer_data[0, 0]
        print("No. of hrs %f" % (tot_time/3600))
        self.avg_fs = int(np.round(rows/tot_time))
        self.offset_in_hr = offset_time
        self.duration_in_hr = duration
        sample_num_start = self.offset_in_hr*self.avg_fs*SECONDS_IN_HR
        sample_num_end = sample_num_start + self.duration_in_hr*self.avg_fs*SECONDS_IN_HR
        return data[sample_num_start:sample_num_end, :]

    def visualize_accelerometer_data(self, data):
        fig, axes = plt.subplots(nrows=3, ncols=2)
        for i, ax in enumerate(axes):
            ax[0].plot(data[:, 0]/3600, data[:, i+1])
            ax[0].set_xlabel('time(hr)')
            ax[0].set_ylabel('rad/s')
            ax[0].grid(True)

            ax[1].plot(data[:, 0]/3600, data[:, 4+i])
            ax[1].set_xlabel('time(hr)')
            ax[1].set_ylabel('m/s^2')
            ax[1].grid(True)
        fig.tight_layout()
        plt.show(block=False)
        plt.pause(.5)

    def save_to_mat(self, acc_data):

        acc_data_dict = {"fs_hz": self.avg_fs,
                         "duration_hr": self.duration_in_hr,
                         "offset_hr": self.offset_in_hr,
                         "timestamp": acc_data[:, 0],
                         "gyro_x": acc_data[:, 1],
                         "gyro_y": acc_data[:, 2],
                         "gyro_z": acc_data[:, 3],
                         "accel_x": acc_data[:, 4],
                         "accel_y": acc_data[:, 5],
                         "accel_z": acc_data[:, 6],
                         "temperature": acc_data[:, 7]}

        savemat(os.path.join(self.config.output_directory_path,
                self.config.output_file_name + '.mat'), acc_data_dict)


# data = np.load(
#     r'E:\Windows\Documents\Northeastern\NEUFRL\IMU_Paper_Part_2\dataset-calib-imu-static2.npy', mmap_mode='r')


def check_config(config):
    try:
        assert(os.path.exists(config.input_file_path)
               ), 'Invalid path for input npy file'
        _, _, ext = file_path_parts(config.input_file_path)
        assert(ext == ".npy"), 'Invalid extention for input file'
        if config.output_directory_path == None and config.output_file_name == None:
            config.output_directory_path, config.output_file_name, _ = file_path_parts(
                config.input_file_path)

        elif config.output_directory_path == None:
            config.output_directory_path, _, _ = file_path_parts(
                config.input_file_path)

        elif config.output_file_name == None:
            config.output_file_name, _, _ = file_path_parts(
                config.input_file_path)

        if (not os.path.exists(config.output_directory_path)):
            os.path.mkdir(config.output_directory_path)
    except AssertionError as msg:
        print(msg)
        sys.exit()


def file_path_parts(full_file_path):
    output_dir, file = os.path.split(full_file_path)
    filename, ext = os.path.splitext(file)
    return output_dir, filename, ext

    # ax[1:0].plot(data[:, 0], data[:, 7])


if __name__ == '__main__':
    argument_parser = argparse.ArgumentParser(
        prog="numpy 2 mat inputs", usage="converts .npy file to .mat")
    argument_parser.add_argument(
        '-i', '--input_file_path', type=str, required=True, help='Input numpy file path', default='./dataset-calib-imu-static2.npy')
    argument_parser.add_argument(
        '-o', '--output_file_name', type=str, help='Output mat file path')
    argument_parser.add_argument(
        '-d', '--output_directory_path', type=str, help='Output mat file directory')
    argument_parser.add_argument(
        '--offset', type=int, help='offset of samples', default=1)
    argument_parser.add_argument(
        '--duration', type=int, help="Duration of samples extracted", default=7)
    config = argument_parser.parse_args()
    check_config(config)
    print(vars(config))
    print("----------------")
    stationary_acclerometer_data = np.load(
        config.input_file_path, mmap_mode='r')

    # Slice data
    tum_npy2mat = TUM_npy2mat(config)
    sliced_data = tum_npy2mat.slice_accelerometer_data(
        stationary_acclerometer_data, config.offset, config.duration)

    tum_npy2mat.save_to_mat(sliced_data)
    tum_npy2mat.visualize_accelerometer_data(
        sliced_data)
    plt.show(block=True)
