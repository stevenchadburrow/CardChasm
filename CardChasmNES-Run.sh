

./asm6/asm6.o CardChasmNES-Bank0.asm CardChasmNES-ProgramROM0.bin ;
./asm6/asm6.o CardChasmNES-Bank1.asm CardChasmNES-ProgramROM1.bin ;
./asm6/asm6.o CardChasmNES-Bank2.asm CardChasmNES-ProgramROM2.bin ;
./asm6/asm6.o CardChasmNES-Bank3.asm CardChasmNES-ProgramROM3.bin ;
./CardChasmNES-Combiner.o CardChasmNES-ProgramROM0.bin CardChasmNES-ProgramROM1.bin CardChasmNES-ProgramROM2.bin CardChasmNES-ProgramROM3.bin CRDCHSM.NES ;
zip CRDCHSM.NES.zip CRDCHSM.NES ;

#./PICnes.o CRDCHSM.NES ;
./Mesen CRDCHSM.NES.zip ;
