s.makeGui; // L, F
s.scope;

(
s = Server.local;
Server.default = s;
s.boot;
)
s.freeAll

{SinOsc.ar(440)}.play;

(
SynthDef('drone', {
	arg pan = 0;
	var freqs, out;
	freqs = Control.names([\freqs]).kr([110, 220, 440, 880]);
	out = DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], PinkNoise.ar(0.005));
	Out.ar(pan, out);
}).add;
)

l = Synth('drone', ["pan", 0]);
r = Synth('drone', ["pan", 1]);

~array = [110, 220, 440, 880, 1320, 1760, 2200, 2640, 3080];
~array = ~array.rotate(1);
~array = ~array.scramble;

~freqs_l = ~array.keep(4);
~freqs_r = ~freqs_l * 1.01;
~freqs_r = ~freqs_l * 1.02;
~freqs_r = ~freqs_l
l.setn(\freqs, ~freqs_l);
r.setn(\freqs, ~freqs_r);
~freqs_l.postln

~freqs_r = ~array.do{arg i; (i+1); };

l.free;
r.free;

(
l = Synth('drone', ["pan", 0]);
r = Synth('drone', ["pan", 1]);
~array = [110, 220, 440, 880, 1320, 1760, 2200, 2640, 3080];

t = Task({
	2.do({
		~freqs_l = ~array.keep(4);
		~freqs_r = ~freqs_l * 1.01;
		l.setn(\freqs, ~freqs_l);
		~freqs_l.postln;
		10.wait;
		r.setn(\freqs, ~freqs_r);
		~freqs_r.postln;
		10.wait;
		~array = ~array.rotate(1);
	});
	l.free;
	r.free;
});
t.start;
)

t.start;
t.pause;
t.resume;
t.reset;
t.stop;


{ DynKlank.ar(`[[800, 1071, 1153, 1723], nil, [1, 1, 1, 1]], Impulse.ar(2, 0, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], Dust.ar(8, 0.1)) }.play;

{ DynKlank.ar(`[[800, 1071, 1353, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(0.007)) }.play;

{ DynKlank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([0.007,0.007])) }.play;



// create multichannel controls directly with literal arrays:
(
SynthDef('help-dynKlank', {| 
	freqs (#[100, 200, 300, 400]), 
	amps (#[1, 0.3, 0.2, 0.05]), 
	rings (#[1, 1, 1, 2])|

	Out.ar(0, DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar * 0.001))
}).add
)

a = Synth('help-dynKlank');

a.setn(\freqs, Array.rand(4, 500, 2000));
a.setn(\amps, Array.exprand(4, 0.01, 1));

{ Out.kr(102, MouseX.kr(1, 2) * Array.rand(4, 500, 2000)) }.play;
a.mapn(\freqs, 102, 4);
