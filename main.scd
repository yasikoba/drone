(

SynthDef('drone', {
	arg pan = 0;
	var freqs, out;
	freqs = Control.names([\freqs]).kr([110, 220, 440, 880]);
	out = DynKlank.ar(`[freqs, nil, [1, 1, 1, 1]], PinkNoise.ar(0.005));
	Out.ar(pan, out);
}).add;

l = Synth('drone', ["pan", 0]);
r = Synth('drone', ["pan", 1]);

~array = [110, 220, 440, 880, 1320, 1760, 2200, 2640, 3080];

t = Task({
	10.do({
		~freqs_l = [~array.at(0),~array.at(1),~array.at(2),~array.at(3)];
		~freqs_r = [~array.at(0)*1.01,~array.at(1)*1.01,~array.at(2)*1.01,~array.at(3)*1.01];
		l.setn(\freqs, ~freqs_l);
		~freqs_l.postln;
		10.wait;
		r.setn(\freqs, ~freqs_r);
		~freqs_r.postln;
		10.wait;
		~array = ~array.rotate(1);
	});
	10.wait;
	l.free;
	r.free;
});
t.start;
)
