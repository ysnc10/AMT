# Automatic Music Transcription 

This repository contains a MATLAB-based implementation of an **Automatic Music Transcription (AMT)** system, developed as part of the **EE430 - Digital Signal Processing** course at METU.

## 🎯 Project Objective

The goal is to transcribe a monophonic music audio signal into symbolic music notation (MIDI numbers). This involves:

- Displaying the **time-domain** waveform and **spectrogram (STFT)** of the input audio.
- Detecting the **onset and offset times** of each musical note.
- Estimating the corresponding **MIDI note number**. 

(  ```
  MIDI_number = 69 + 12 * log2(freq / 440)
  ```

  where `freq` is the detected frequency in Hz, and 440 Hz corresponds to the A4 note.)

- Groups temporal note segments based on continuity.
- Visualizing both the detected and the ground-truth MIDI notes.
- Saving the output as a `.csv` file.

## 🧠 Key Features

- Uses **Short-Time Fourier Transform (STFT)** for time-frequency analysis.
- Converts spectral peaks to **MIDI note numbers**.
- Groups temporal note segments based on continuity.
- Compares detected notes with **ground-truth annotations** visually and quantitatively.
- Saves results to `detected_notes.csv`.
