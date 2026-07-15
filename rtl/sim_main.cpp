#include "Vcontrol_unit.h"           //V + TOP MODULE name, not the filename
#include "verilated.h"
#include "verilated_vcd_c.h"    // needed for VCD tracing



// the only ai generated code in the project.

int main(int argc, char** argv) {
    VerilatedContext* ctx = new VerilatedContext;
    ctx->commandArgs(argc, argv);
    Vcontrol_unit * top = new Vcontrol_unit{ctx};   // your DUT instance

    // --- tracing setup (all three of these are required) ---
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);         // 99 = how many hierarchy levels to trace
    tfp->open("wave.vcd");

    top->clk = 0;
    top->rst = 1;                // start in reset

    while (ctx->time() < 80 && !ctx->gotFinish()) {
        top->clk = !top->clk;            // YOU toggle the clock. There's no auto clock.
        if (ctx->time() > 8) top->rst = 0;   // release reset after a few units
        top->eval();                     // nothing updates until you call this
        tfp->dump(ctx->time());          // record this instant into the VCD
        ctx->timeInc(1);                 // advance sim time (skip this = flat waveform)
    }

    tfp->close();     // skip this and your VCD is empty/truncated
    top->final();     // ditto
    delete top;
    delete ctx;
    return 0;
}
