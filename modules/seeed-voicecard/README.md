# seeed-voicecard

[![Join the chat at https://gitter.im/seeed-voicecard/Lobby](https://badges.gitter.im/seeed-voicecard/Lobby.svg)](https://gitter.im/seeed-voicecard/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The drivers of [ReSpeaker Mic Hat](https://www.seeedstudio.com/ReSpeaker-2-Mics-Pi-HAT-p-2874.html) for Raspberry Pi.

## ReSpeaker Mic Hat

[![](https://github.com/SeeedDocument/MIC_HATv1.0_for_raspberrypi/blob/master/img/mic_hatv1.0.png?raw=true)](https://www.seeedstudio.com/ReSpeaker-2-Mics-Pi-HAT-p-2874.html)

While the upstream wm8960 codec is not currently supported by current Pi kernel builds, upstream wm8960 has some bugs, we had fixed it. we must it build manually.

Check that the sound card name matches the source code seeed-voicecard.

```bash
#for ReSpeaker 2-mic
pi@raspberrypi:~/seeed-voicecard $ aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: ALSA [bcm2835 ALSA], device 0: bcm2835 ALSA [bcm2835 ALSA]
  Subdevices: 8/8
  Subdevice #0: subdevice #0
  Subdevice #1: subdevice #1
  Subdevice #2: subdevice #2
  Subdevice #3: subdevice #3
  Subdevice #4: subdevice #4
  Subdevice #5: subdevice #5
  Subdevice #6: subdevice #6
  Subdevice #7: subdevice #7
card 0: ALSA [bcm2835 ALSA], device 1: bcm2835 ALSA [bcm2835 IEC958/HDMI]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: seeed2micvoicec [seeed-2mic-voicecard], device 0: bcm2835-i2s-wm8960-hifi wm8960-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
pi@raspberrypi:~/seeed-voicecard $ arecord -l
**** List of CAPTURE Hardware Devices ****
card 1: seeed2micvoicec [seeed-2mic-voicecard], device 0: bcm2835-i2s-wm8960-hifi wm8960-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
pi@raspberrypi:~/seeed-voicecard $ 
```
If you want to change the alsa settings, You can use `sudo alsactl --file=/etc/voicecard/wm8960_asound.state  store` to save it.



#### Next step
Go to https://github.com/respeaker/mic_hat to build voice enabled projects with Google Assistant SDK or Alexa Voice Service.

Enjoy !

### FAQ

When you encounter any installation and use problems when you start your ReSpeaker Pi hat, please use the following image for testing. We have installed seeed-voicecard based on the latest PI image, which can be used by burning it directly on SD. If this still cannot solve your problem, you can ask in the issue. We will try our best to solve your problem.

[Origin repo link](https://github.com/respeaker/seeed-voicecard)
