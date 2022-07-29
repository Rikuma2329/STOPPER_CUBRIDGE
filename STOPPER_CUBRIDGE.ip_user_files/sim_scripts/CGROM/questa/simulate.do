onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib CGROM_opt

do {wave.do}

view wave
view structure
view signals

do {CGROM.udo}

run -all

quit -force
