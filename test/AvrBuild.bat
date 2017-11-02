@ECHO OFF
"d:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\My Documents\PROJECT\avr\test\labels.tmp" -fI -W+ie -o "D:\My Documents\PROJECT\avr\test\test.hex" -d "D:\My Documents\PROJECT\avr\test\test.obj" -e "D:\My Documents\PROJECT\avr\test\test.eep" -m "D:\My Documents\PROJECT\avr\test\test.map" "D:\My Documents\PROJECT\avr\test\test.asm"
