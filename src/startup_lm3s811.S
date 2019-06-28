.syntax unified
.cpu    cortex-m3
.thumb

.global g_pfnVectors
.global Default_Handler

/**
 * @brief Symbol for determining address of .data section initial values block.
 */
.word _data_values_start

/**
 * @brief Symbol for determining start address of .data section.
 */
.word _data_start

/**
 * @brief Symbol for end address of .data section.
 */
.word _data_end

/**
 * @brief Symbol for determining start address of .bss section.
 */
.word _bss_start

/**
 * @brief Symbol for end address of .bss section.
 */
.word _bss_end

/**
 * @brief Application entry code.
 *
 * CPU starts execution from here just after reset. This routine prepares static
and global variables. Then jump to main() is performed and user application
begins execution.
 */
.section .text.Reset_Handler
.weak    Reset_Handler,
.type    Reset_Handler, %function
Reset_Handler:
    /* Set SP to the end of RAM. */
    ldr   r0, =_RAM_END
    mov   sp, r0

    /* Copy data segment initial values from Flash to RAM. */
    ldr   r0, =_data_start
    ldr   r1, =_data_end
    ldr   r2, =_data_values_start
    movs  r3, #0

    /* R1 contains bytes to copy. */
    subs  r1, r1, r0

    b     copy_data_check

copy_data_loop:
    ldr   r4, [r2, r3]
    str   r4, [r0, r3]
    adds  r3, #4

copy_data_check:
    cmp   r3, r1
    bcc   copy_data_loop

    /* Zero fill BSS section. */
    ldr   r0, =_bss_start
    ldr   r1, =_bss_end
    movs  r2, #0
    b     zero_bss_check

zero_bss_loop:
    str   r2, [r0]
    adds  r0, #4

zero_bss_check:
    cmp   r0, r1
    bcc   zero_bss_loop

/* Call user application main() */
    b     main

.size Reset_Handler, .-Reset_Handler

/**
 * brief Function for catching default interrupts.
 *
 * Any interrupt handler not overriden explicitely will be trapped inside this function for debugger to examine.
 */
.section .text.Default_Handler,"ax",%progbits
Default_Handler:
    b   Default_Handler
.size     Default_Handler, .-Default_Handler

/**
 * @brief Vector table.
 */
.section .isr_vector,"a",%progbits
.type    g_pfnVectors, %object
.size    g_pfnVectors, .-g_pfnVectors

g_pfnVectors:
    .word _RAM_END
    .word Reset_Handler
    .word NonMaskableInt_Handler
    .word 0
    .word MemoryManagement_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVCall_Handler
    .word DebugMonitor_Handler
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler
    .word GPIOPortA_Handler
    .word GPIOPortB_Handler
    .word GPIOPortC_Handler
    .word GPIOPortD_Handler
    .word GPIOPortE_Handler
    .word UART0_Handler
    .word UART1_Handler
    .word SSI0_Handler
    .word I2C0_Handler
    .word 0
    .word PWMGen0_Handler
    .word PWMGen1_Handler
    .word PWMGen2_Handler
    .word 0
    .word ADCSeq0_Handler
    .word ADCSeq1_Handler
    .word ADCSeq2_Handler
    .word ADCSeq3_Handler
    .word Watchdog_Handler
    .word Timer0A_Handler
    .word Timer0B_Handler
    .word Timer1A_Handler
    .word Timer1B_Handler
    .word Timer2A_Handler
    .word Timer2B_Handler
    .word Comp0_Handler
    .word 0
    .word 0
    .word SysCtrl_Handler
    .word FlashCtrl_Handler

/**
 * @brief Weak aliases for interrupt handlers.
 *
 * Interrupt handlers points to Default_Hander by default. As they are weak
 * aliases, they can be overriden and therefore be used in user code.
 */

.weak      NonMaskableInt_Handler
.thumb_set NonMaskableInt_Handler,Default_Handler

.weak      MemoryManagement_Handler
.thumb_set MemoryManagement_Handler,Default_Handler

.weak      BusFault_Handler
.thumb_set BusFault_Handler,Default_Handler

.weak      UsageFault_Handler
.thumb_set UsageFault_Handler,Default_Handler

.weak      SVCall_Handler
.thumb_set SVCall_Handler,Default_Handler

.weak      DebugMonitor_Handler
.thumb_set DebugMonitor_Handler,Default_Handler

.weak      PendSV_Handler
.thumb_set PendSV_Handler,Default_Handler

.weak      SysTick_Handler
.thumb_set SysTick_Handler,Default_Handler

.weak      GPIOPortA_Handler
.thumb_set GPIOPortA_Handler,Default_Handler

.weak      GPIOPortB_Handler
.thumb_set GPIOPortB_Handler,Default_Handler

.weak      GPIOPortC_Handler
.thumb_set GPIOPortC_Handler,Default_Handler

.weak      GPIOPortD_Handler
.thumb_set GPIOPortD_Handler,Default_Handler

.weak      GPIOPortE_Handler
.thumb_set GPIOPortE_Handler,Default_Handler

.weak      UART0_Handler
.thumb_set UART0_Handler,Default_Handler

.weak      UART1_Handler
.thumb_set UART1_Handler,Default_Handler

.weak      SSI0_Handler
.thumb_set SSI0_Handler,Default_Handler

.weak      I2C0_Handler
.thumb_set I2C0_Handler,Default_Handler

.weak      PWMGen0_Handler
.thumb_set PWMGen0_Handler,Default_Handler

.weak      PWMGen1_Handler
.thumb_set PWMGen1_Handler,Default_Handler

.weak      PWMGen2_Handler
.thumb_set PWMGen2_Handler,Default_Handler

.weak      ADCSeq0_Handler
.thumb_set ADCSeq0_Handler,Default_Handler

.weak      ADCSeq1_Handler
.thumb_set ADCSeq1_Handler,Default_Handler

.weak      ADCSeq2_Handler
.thumb_set ADCSeq2_Handler,Default_Handler

.weak      ADCSeq3_Handler
.thumb_set ADCSeq3_Handler,Default_Handler

.weak      Watchdog_Handler
.thumb_set Watchdog_Handler,Default_Handler

.weak      Timer0A_Handler
.thumb_set Timer0A_Handler,Default_Handler

.weak      Timer0B_Handler
.thumb_set Timer0B_Handler,Default_Handler

.weak      Timer1A_Handler
.thumb_set Timer1A_Handler,Default_Handler

.weak      Timer1B_Handler
.thumb_set Timer1B_Handler,Default_Handler

.weak      Timer2A_Handler
.thumb_set Timer2A_Handler,Default_Handler

.weak      Timer2B_Handler
.thumb_set Timer2B_Handler,Default_Handler

.weak      Comp0_Handler
.thumb_set Comp0_Handler,Default_Handler

.weak      SysCtrl_Handler
.thumb_set SysCtrl_Handler,Default_Handler

.weak      FlashCtrl_Handler
.thumb_set FlashCtrl_Handler,Default_Handler

