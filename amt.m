% Read the Audio File
[audio, fs] = audioread("C:\Users\hsnct\Downloads\Yeni klasör (6)\audio-samples (2)\audio-samples\god_father.wav");
audio = audio(:,1); % Ensure mono-channel
time = (0:length(audio)-1)/fs;

% Pre-process the Audio Signal
audio = audio / max(abs(audio)); % Normalize the audio

% Plot the time-domain representation
t = (0:length(audio)-1)/fs;
figure;
plot(t, audio);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time Domain Representation');


% Short-Time Fourier Transform (STFT)
window_length = 8192; % Further increased window length for even better frequency resolution
overlap = window_length- window_length / 4; %  more overlap (better time resolution)
nfft = 8192; % Further increased FFT length for even better frequency resolution
[S, F, T] = stft(audio, fs, 'Window', hamming(window_length), 'OverlapLength', overlap, 'FFTLength', nfft);%stft

% Display the STFT
figure;
imagesc(T, F, 20*log10(abs(S)));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
ylim([0 1600]);
title('Spectrogram');
colorbar;

% Note Detection
threshold = 35; % dB threshold for note detection
detected_notes = [];

for t = 1:length(T)
    spectrum = 20*log10(abs(S(:,t)));
    peaks = find(spectrum> threshold); 
    for peak = peaks'
        freq = F(peak);
        midi_num = round(69 + 12*log2(freq/440)); % Convert frequency to MIDI number
        detected_notes = [detected_notes; T(t), midi_num];
    end
end
notes = [];
for midi_number=21:108
    p=find(abs(detected_notes(:,2)-midi_number)<0.1);
    pt=detected_notes(p,1);
    i=2;group_produce=0;
    while i<=length(p)
        if pt(i)<pt(i-1)+0.05
            if group_produce==0
                start_time = detected_notes(p(i-1), 1);  
                group_produce=1;
            end
        end    
        if pt(i)>pt(i-1)+0.05
            if group_produce==1
                end_time = detected_notes(p(i-1), 1);
                group_produce=0;
                notes = [notes; start_time, end_time, midi_number];
            end
        end  
        i=i+1;
    end
    if group_produce==1
        end_time = detected_notes(p(length(p)), 1);
        notes = [notes; start_time, end_time, midi_number];
        group_produce=0;
    end    
end    

% Display the detected MIDI notes
figure;
hold on;
for i = 1:size(notes, 1)
    plot([notes(i, 1), notes(i, 2)], [notes(i, 3), notes(i, 3)], 'LineWidth', 2, 'Color', 'r');
end
xlabel('Time (s)');
ylabel('MIDI Number');
title('Detected MIDI Notes');
hold off;
ylim([40 105]);
notes

ground_truth = readtable("C:\Users\hsnct\Downloads\Yeni klasör (6)\groud-truth-midi\groud-truth-midi\god_father.csv");

gt_start_times = ground_truth.Var1;
gt_end_times = ground_truth.Var2;
gt_midi_numbers = ground_truth.Var3;

figure;
hold on;
for i = 1:length(gt_start_times)
    plot([gt_start_times(i), gt_end_times(i)], [gt_midi_numbers(i), gt_midi_numbers(i)], 'LineWidth', 1, 'Color', 'b');
end
xlabel('Time (s)');
ylabel('MIDI Number');
title('Ground Truth (Blue) MIDI Numbers');
hold off;

% Save results
notes_table = array2table(notes, 'VariableNames', {'Start_Time', 'End_Time', 'MIDI_Number'});
writetable(notes_table, 'detected_notes.csv');

disp('Note segmentation completed. Results saved to detected_notes.csv');

