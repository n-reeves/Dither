SndBuf pianointro => dac;
SndBuf pianosection1 => dac;
SndBuf pianosection2 => dac;
SndBuf pianoend => dac;

me.dir() + "intropiano.wav" => pianointro.read;
me.dir() + "section1piano.wav" => pianosection1.read;
me.dir() + "section2piano.wav" => pianosection2.read;
me.dir() + "endpiano.wav" => pianoend.read;

0 => pianosection1.gain;
0 => pianosection2.gain;
0 => pianoend.gain;

SndBuf vocalintro => dac;
SndBuf vocalsection1 => dac;
SndBuf vocalsection2 => dac;
SndBuf vocalend => dac;

me.dir() + "introaudio.wav" => vocalintro.read;
me.dir() + "section1audio.wav" => vocalsection1.read;
me.dir() + "section2audio.wav" => vocalsection2.read;
me.dir() + "endaudio.wav" => vocalend.read;

0 => vocalsection1.gain;
0 => vocalsection2.gain;
0 => vocalend.gain;

SinOsc sin => dac;
0 => sin.gain;

pianointro.samples() => int samples;
pianosection1.samples()/8 => int chordLength;

//chordLength::samp => dur tick;



// intro (vocal randomization)
// length: 26482 ms
// sample rate: 44100

chordLength*16 => int introLength;

0 => int sumMS;

int vocalGrainLength;

int vocalPos;

sumMS + vocalGrainLength => sumMS;

while (sumMS < 26482 ){
    
    
    if (sumMS <= 26482/2){
        Math.random2(500, 800) => vocalGrainLength;
        Math.random2(0, samples) => vocalPos;
    } else  {
        Math.random2(800, 1200) => vocalGrainLength;
        Math.random2(samples/2, samples) => vocalPos;
    }
    
    if (sumMS >= 25482){
        26482 - sumMS => vocalGrainLength;
        }

    Math.random2(0, samples) => vocalPos;
    
    vocalPos => vocalintro.pos;
    
    vocalGrainLength::ms => now;
    
    sumMS + vocalGrainLength => sumMS;
    
}
0 => vocalintro.gain;
0 => pianointro.gain;

// Middle.1 (Chord and vocal randomization)
// File length: 13241 ms
// sample rate: 44100

pianosection1.samples() => samples;
0 => pianosection1.pos;
0 => vocalsection1.pos;
1 => pianosection1.gain;
.8 => vocalsection1.gain;
.1 => sin.gain;

0 => sumMS;
0 => int sumMS2;
int length;
int chordIndex;
while(sumMS < 13241 ) {
    Math.random2(0,7) => chordIndex;
    samples/8 * chordIndex => pianosection1.pos;
    1655 => length;
    
    if(chordIndex == 0|| chordIndex ==  2){
        Std.mtof(42) => sin.freq;
    }
    if(chordIndex == 1|| chordIndex ==  3 ||chordIndex == 5|| chordIndex ==  7){
        Std.mtof(37) => sin.freq;
    }
    if(chordIndex == 4|| chordIndex == 6 ){
        Std.mtof(36) => sin.freq;
    }

    
    if(sumMS == 13240){
        break;
    } 
    while(sumMS2 < 1655){
        Math.random2(300, 600) => vocalGrainLength;
        if(1655 - sumMS2 < 600 ){
            1655 - sumMS2 => vocalGrainLength;
        }
        if(chordIndex%2 == 0){
            chordIndex * samples/8 + 44100  + Math.random2(0, 20000) => vocalsection1.pos;
        } else {
            chordIndex* samples/8 + Math.random2(0, 20000) => vocalsection1.pos;
        }
        
        vocalGrainLength + sumMS2 => sumMS2;
        vocalGrainLength::ms => now;
    }
    0 => sumMS2;
    sumMS + 1655 => sumMS;
}
0 => pianosection1.gain;
0 => vocalsection1.gain;

// Middle.2 (Chord and vocal randomization)
// File length: 13241 ms
// sample rate: 44100
0 => pianosection2.pos;
0 => vocalsection2.pos;
1 => pianosection2.gain;
.9 => vocalsection2.gain;
0 => sumMS;
0 => sumMS2;

while(sumMS < 13241 ) {
    Math.random2(0,7) => chordIndex;
    if (sumMS == 11585){
        7 => chordIndex;
    }
    samples/8 * chordIndex => pianosection2.pos;
    1655 => length;
    
    if(chordIndex == 0|| chordIndex ==  2){
        Std.mtof(42) => sin.freq;
    }
    if(chordIndex == 1|| chordIndex ==  3 ||chordIndex == 5){
        Std.mtof(37) => sin.freq;
    }
    if(chordIndex == 7){
        Std.mtof(33) => sin.freq;
    }
    
    if(sumMS == 13240){
        break;
    } 
    
    if(chordIndex%2 == 0){
            chordIndex * samples/8 + Math.random2(0, 20000) => vocalsection1.pos;
        } else {
            chordIndex* samples/8 + 44100 + Math.random2(0, 20000) => vocalsection1.pos;
        }
    while(sumMS2 < 1655){
        Math.random2(600, 800) => vocalGrainLength;
        if(1655 - sumMS2 < 600 ){
            1655 - sumMS2 => vocalGrainLength;
        }
        chordIndex * samples/8 => vocalsection2.pos;
        vocalGrainLength + sumMS2 => sumMS2;
        vocalGrainLength::ms => now;
    }
    0 => sumMS2;
    sumMS + 1655 => sumMS;
}

0 => pianosection2.gain;
0 => vocalsection2.gain;
// End

Std.mtof(32) => sin.freq;
0 => pianoend.pos;
0 => vocalend.pos;
1 => pianoend.gain;
.7 => vocalend.gain;

14::second => now;