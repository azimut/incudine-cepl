# incudine-cepl

## Description

This is (very) basic example of how to send wave data from [incudine](http://incudine.sourceforge.net/) to [CEPL](https://github.com/cbaggers/cepl).

## Demo

![result](https://i.imgur.com/n0sTfaW.gif "example")

## Usage

Put this repo on ~/quicklisp/local-projects/ along with incudine. And then on SLIME load it.

```
> (ql:quickload :incudine-cepl)
> (in-package :incudine-cepl)
```

Start things in this order.
```
> (runplay :start)
> (rt-start)
> (monitor-master :id 99)
> (test-dsp :id 10)
> (incudine:free (node 10))
```

The code that controls what you see on the screen is at `(defun-g fract ...` try playing around with that function.

## Using incudine
Check https://github.com/titola/incudine/blob/master/INSTALL
Also note that you need an audio backend configured. Default on linux is JACK. So you can either:
1) Configure jack properly, see `qjackctl`
2) Start a dummy jack instance (no audio output). By doing:
`/usr/bin/jackd -ddummy -r44100`
3) Use Portaudio in linux, by default disabled. Change the *audio-driver* on incudinerc.
```
cp incudine/incudinerc ~/.incudinerc
nano ~/.incudinerc
```

## TODO
- Add fft data
- Look for optimizations/bugs
