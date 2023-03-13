require 'rmodbus'
require 'serialport'
include ModBus

#setting
PORT = "/dev/ttyUSB0"   # /dev/ttyUSB0

BAUD = 9600 
uid = 1
options = {data_bits: 8, stop_bits: 1, parity: SerialPort::NONE} 

cl = ModBus::RTUClient.new(PORT, BAUD, options)

cl.read_retries = 2
cl.debug = true

usage_setting = [0,0,0,0,0] #改使用設置

#test

#預先增壓
pressure_mode = cl.with_slave(1).read_coils(2016,1)
if pressure_mode == [0]
    cl.with_slave(1).write_single_coil(2016,1) #全部增壓
    puts '全部增壓'
else
    puts '已全部增壓完成'
end


#使用設置
cl.with_slave(1).write_multiple_coils(2016,usage_setting)
p cl.with_slave(1).read_coils(2016,5)






cl.with_slave(1).write_single_coil(2001,1) #啟動



#example

=begin
cl.with_slave(1).read_coils(2140,5)
cl.with_slave(1).write_single_coil(2048,2)
cl.with_slave(1).write_multiple_coils(2048,[1,0,0,1,0,1,0,1,1])

cl.with_slave(1).read_holding_registers(2048,2)
cl.with_slave(1).write_single_register(6101,30)
cl.with_slave(1).write_multiple_registers(6101,[10,0x55])

=end