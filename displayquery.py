#!/usr/bin/env python3
import sys
import ctypes
import sdl2
import sdl2.ext
from Xlib import X, display, Xutil
from Xlib.ext import randr

def sdl_get_display_info(name):
    displays = sdl2.ext.displays.get_displays()
    for output in displays:
        if name == output.name.split(' ', 1)[0]:
            mode = output.current_mode
            return {
                'index': output.index,
                'name': output.name,
                'mode': mode
            }

    return {}

def get_display_info(name):
    d = display.Display()
    result = []
    info = d.screen(0)
    window = info.root
    primary = window.xrandr_get_output_primary()

    res = randr.get_screen_resources(window)
    for output in res.outputs:
        params = d.xrandr_get_output_info(output, res.config_timestamp)
        if not params.crtc:
           continue

        if name == '' or ((name == 'primary' and (params.name == 'gamescope' or primary.output == output)) or name == params.name):
            sdl = sdl_get_display_info(params.name)
            if sdl != {}:
                crtc = d.xrandr_get_crtc_info(params.crtc, res.config_timestamp)
                result.append({
                    'name': params.name,
                    'primary': primary.output == output,
                    'index': sdl['index'],
                    'width': crtc.width,
                    'height': crtc.height,
                    'refresh_rate': sdl['mode'].refresh_rate
            })

    return result

def main():
    if len(sys.argv) < 2:
        return -1

    sdl2.ext.init()

    if sys.argv[1] == 'query':
        name = ''
        if len(sys.argv) >= 3:
            name = sys.argv[2]

        info = get_display_info(name)
        for i in info:
            print("{},{},{},{},{},{}".format(i['name'],int(i['primary']),i['index'],i['width'],i['height'],i['refresh_rate']))

    sdl2.ext.quit()

if __name__ == "__main__":
    sys.exit(main())