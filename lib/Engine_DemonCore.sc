
Engine_DemonCore : CroneEngine {

  var <synth;

  *new { arg context, doneCallback;
    ^super.new(context, doneCallback);
  }

  alloc {
    SynthDef(\demoncore, {
      arg out, amp = 0.5, density = 400, mix = 0.5, room = 0.15, damp = 0.5, resf = 440, resamount = 0.5;
      var noise1, verb1, sig;
      noise1 = Dust.ar(density,amp);
      
      
  //    sig = noise1;
 
  //sig = FreeVerb.ar(sig,mix,room,damp) ! 2;
 
 sig = MoogLadder.ar(noise1,resf,resamount) ! 2;
 
 
   sig = FreeVerb.ar(sig,mix,room,damp) ! 2;
 
       Out.ar(out, sig);
      }).add;

      context.server.sync;

      synth = Synth.new(\demoncore, [
        \out, context.out_b.index],
        context.xg);
        

      this.addCommand("resf", "f", {|msg|
      synth.set(\resf, msg[1]);
    });


      this.addCommand("damp", "f", {|msg|
      synth.set(\damp, msg[1]);
    });

      this.addCommand("room", "f", {|msg|
      synth.set(\room, msg[1]);
    });

      this.addCommand("mix", "f", {|msg|
      synth.set(\mix, msg[1]);
    });

      this.addCommand("resamount", "f", {|msg|
      synth.set(\resamount, msg[1]);
    });

      this.addCommand("density", "f", {|msg|
      synth.set(\density, msg[1]);
    });
    
      this.addCommand("amp", "f", {|msg|
      synth.set(\amp, msg[1]);
    });


  }
  // define a function that is called when the synth is shut down
  free {
    synth.free;
  }
}