----------------------------------------------------------------

This paper describes a process of **creating a hardware and a software of a medical device** digital ultrasonic stethoscope.

----------------------------------------------------------------

The author starts with requered **features** of the device:
    - high sampling rate (more than 100kHz)
    - ability to register/acqure sound in ultrasonic range (more than 20kHz)

In the next section author analyzes(эналайзес) **similar products** on the market.

----------------------------------------------------------------

Then the writer describes the steps of **creating the hardware** of device: 
    - choosing right microphone
    - creating the signal amplifier circuit (sərkət)
    - choosing right ADC (AnalOg-to-digital converter)

----------------------------------------------------------------
Then there is the **software description**
    - the installation guide
    - description of the User Interface
    - description of main features of software such as 
    - realtime visualisation of the signal
    - compute signal's fft and wavelet spectre
    - able to record signal for future processing
    - able to do parallel computations using NVidia CUDA technology

----------------------------------------------------------------

In the **conclusion** section:
- **applications** of device and software
    - help to do medical analysis and recognize diseases
- proposal for **future development** of project
    - use microphone and amplifier of better quality
    - software performance improvements using parallel computations on multiple core processor or videocard
    - machine learning algorithms to classify lungs and heart diseases

----------------------------------------------------------------
