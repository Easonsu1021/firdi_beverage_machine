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

#使用者設置
usage_setting = [0,0,0,0,0] #改使用設置
filling_time = [10,20,0,0,0] #改填充時間(單位0.1s)
time = 50 #單一使用時間

#main
p "Enter mode:"
while true
    mode = gets.to_i

    if (mode == 2)
        #空壓桶槽
        cl.with_slave(1).write_single_coil(2120,1)

        #卡匣固定
        cl.with_slave(1).write_single_coil(2144,1) #第四個
        
        #使用裝置
        cl.with_slave(1).write_single_coil(2814,1)

        #單一增壓
        cl.with_slave(1).write_single_coil(2134,1) #第四個

        #輸入時間
        cl.with_slave(1).write_single_register(6104,time)
        
        #啟動
        cl.with_slave(1).write_single_coil(2000,1) 
        
        puts 'active' 

    elsif(mode == 3)
        #停止
        cl.with_slave(1).write_single_coil(2000,0) 
         puts 'stop'
    else
        #reset
        cl.with_slave(1).write_single_coil(2120,0)
        cl.with_slave(1).write_single_coil(2144,0)
        cl.with_slave(1).write_single_coil(2814,1)
        cl.with_slave(1).write_single_coil(2134,0)
        cl.with_slave(1).write_single_register(6104,0)
        puts 'reset'
        break

    end
end
    
# #全部增壓
# pressure_mode = cl.with_slave(1).read_coils(2016,1)
# #puts pressure_mode
# if pressure_mode == [0]
#     cl.with_slave(1).write_single_coil(2016,1) #全部增壓
#     #puts  cl.with_slave(1).read_coils(2016,1)
#     puts '全部增壓'
# else
#     puts '已全部增壓完成'
# end


# #使用設置
# cl.with_slave(1).write_multiple_coils(2016,usage_setting)
# p cl.with_slave(1).read_coils(2016,5)

# #填充時間
# cl.with_slave(1).write_multiple_registers(6102,filling_time)
# p cl.with_slave(1).read_holding_registers(6102,5)


# #啟動
# cl.with_slave(1).write_single_coil(2001,1) #啟動



# #example

# =begin
# cl.with_slave(1).read_coils(2140,5)
# cl.with_slave(1).write_single_coil(2048,2)
# cl.with_slave(1).write_multiple_coils(2048,[1,0,0,1,0,1,0,1,1])

# cl.with_slave(1).read_holding_registers(2048,2)
# cl.with_slave(1).write_single_register(6101,30)
# cl.with_slave(1).write_multiple_registers(6101,[10,0x55])

# =end