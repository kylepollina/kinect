Some programs interact with kinects using the processing framework.

- [Rainbow Hand painting](https://www.youtube.com/embed/WwX4lv0vOSY)
- [Depth Towers](https://www.youtube.com/embed/l7ivoH3AzZU)
- [Depth Finder](https://www.youtube.com/embed/UsiiZcQ8KB8)

## Setup (macOS)

1. Install [Processing](https://processing.org/download)
1. Install [OpenKinect](https://openkinect.org/wiki/Getting_Started)
  1. For macos:
    `brew install libfreenect`
1. Open Processing. IN the menu bar click `Sketch > Import Library > Add library`
1. Search and install `OpenKinect for Processing` by Daniel Schiffman et.all
1. If getting error `NoClassDefFoundError: com/sun/jna/Library` then download the JNA jar file listed here: https://github.com/java-native-access/jna#jna
  1. Open Processing. In the menu bar click `Sketch > Add file...` and select the jar file you downloaded
