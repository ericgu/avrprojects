
void init(void);

extern char command;
extern char command_ready;

#define COMMAND_OK 1
#define COMMAND_18 2
#define COMMAND_ON 3
#define COMMAND_OFF 4

void AllOff(void);
void AllOn(void);

#define TCNT1H_VALUE 0xCF
#define TCNT1L_VALUE 0x2B
