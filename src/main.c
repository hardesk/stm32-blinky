#include <stm32f030x6.h>

#define CAT(x, y) CAT1(x, y)
#define CAT1(x, y) x ## y
#define SV(B, V) ( ((unsigned)(V) << B ## _Pos)) & B ## _Msk

void init_ports()
{
    RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
    RCC->APB2ENR |= RCC_APB2ENR_TIM16EN;

    // Configure Port A
    // pin0: ouput
    {
        // 0:input 1:output, 2:alternate-function, 3:analog
		GPIOA->MODER |= SV(GPIO_MODER_MODER4, 1);

        // x0: Low speed, 01:Medium speed, 11:High speed
        GPIOA->OSPEEDR |= SV(GPIO_OSPEEDR_OSPEEDR4, 0);

        // 0:push-pull 1:open-drain
       	GPIOA->OTYPER &= ~GPIO_OTYPER_OT_4;

        // 00:No pull-up & pull-down, 01:Pull-up, 10:Pull-down, 11:Reserved
        GPIOA->PUPDR |= SV(GPIO_PUPDR_PUPDR4, 0);
    }

#define FREQ_MHZ 10

    TIM16->ARR = 0xffff;
    TIM16->CR1 |= SV(TIM_CR1_CKD, 0) | SV(TIM_CR1_CEN, 1);
    TIM16->PSC = FREQ_MHZ*1000-1;

}

void delay_ms(int ms)
{
    uint16_t start = TIM16->CNT;
    while (TIM16->CNT - start < ms)
        ;
}

int ms = 500;

int main()
{
	init_ports();

	while (1) {
        delay_ms(ms);
		//GPIOA->ODR |= 0x01 << 13;
        GPIOA->BSRR = 0x1 << 4;

        delay_ms(ms);
        //GPIOA->ODR &= 0x1 << (16+13);
        GPIOA->BSRR = 0x1 << (16+4);
    }
}
