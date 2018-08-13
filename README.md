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

## TODO
- Add fft data
- Look for optimizations/bugs
