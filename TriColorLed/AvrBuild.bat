@ECHO OFF
"d:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\My Documents\PROJECT\avr\TriColorLed\labels.tmp" -fI -W+ie -o "D:\My Documents\PROJECT\avr\TriColorLed\TriColorLed.hex" -d "D:\My Documents\PROJECT\avr\TriColorLed\TriColorLed.obj" -e "D:\My Documents\PROJECT\avr\TriColorLed\TriColorLed.eep" -m "D:\My Documents\PROJECT\avr\TriColorLed\TriColorLed.map" "D:\My Documents\PROJECT\avr\TriColorLed\TriColorLed.asm"