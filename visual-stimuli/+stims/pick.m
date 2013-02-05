function pick    % stims.pick allows picking one of several preconfigured visual stimuli

reload(psy.getSchema)  % preload to speed up the initialization

parentTable = common.Animal;


simpleGrating = struct(...
    'prompt', 'grating: 1s ON/1s OFF (384 s)', ...
    'logger', stims.core.Logger(psy.Session, psy.Condition, psy.Trial, psy.Grating), ...
    'constants', ...
    struct(...
    'stimulus', 'grating', ...  % stimulus name recorded in the session table
    'monitor_distance', 10, ... (cm)
    'monitor_size', 7, ...      (inches) diagonal
    'monitor_aspect', 1.7, ...  (physical aspect ratio W/H)
    'resolution_x', 1024, ...   (pixels)
    'resolution_y',  600 ...    (pixels)
    ), ...
    'blocks', 2, ...
    'stim', {{
    
    setParams(stims.Grating, ...
    'direction', 0:15:359, ...
    'pre_blank', 1.0, ...
    'trial_duration', 1.0, ...
    'aperture_radius', 2.0, ...
    'init_phase', 0:0.25:0.75...
    )
    
    }});


electricalGrating = struct(...
    'prompt', 'Jake''s electrical stim (1260 s)', ...
    'logger', stims.core.Logger(psy.Session, psy.Condition, psy.Trial, psy.Grating), ...
    'constants', struct(...
    'stimulus', 'grating', ... % stimulus name recorded in the session table
    'monitor_distance', 10, ...  (cm)
    'monitor_size', 7, ...       (inches) diagonal
    'monitor_aspect', 1.7, ...   (physical aspect ratio W/H)
    'resolution_x', 1024, ...     (pixels)
    'resolution_y',  600 ...      (pixels)
    ), ...
    'blocks', 10, ...
    'stim', {{
    
    setParams(stims.Grating, ...
    'second_photodiode', -1, ...
    'direction', 0:15:359, ...
    'pre_blank', 0.0, ...
    'trial_duration', 0.25, ...
    'aperture_radius', 2.0)
    
    stims.Pause(60)
    
    setParams(stims.Grating, ...
    'second_photodiode',  1, ...
    'direction', 0:15:359,  ...
    'pre_blank', 0.0, ...
    'trial_duration', 0.25, ...
    'aperture_radius', 2.0)
    
    stims.Pause(60)
    }}...
    );

% menu items callback
menu = [
    simpleGrating
    electricalGrating
    ];

clc, disp 'Welcome to stims.pick'

% enter primary key
while true
    try
        for keyField = parentTable.primaryKey
            key.(keyField{1}) = input(sprintf('Enter %s: ', keyField{1}));
            assert(~isempty(key.(keyField{1})), 'cannot have empty key')
        end
        disp 'Entered:'
        disp(key)
        assert(count(parentTable & key)==1, 'not found in database')
        break
    catch err
        disp(err.message)
    end
end

assert(isempty(javachk('desktop')), 'no MATLAB desktop! Restart.')
fprintf '\nAt runtime, press numbers to select stimulus, "r"=run, "q"=quit:\n'
for i = 1:length(menu)
    fprintf('%d. %s\n', i, menu(i).prompt)
end
fprintf \n\n

disp 'While the screen is blanked you can:'
disp '   press 1-9 to select or change the stimulus (memorize them now)'
disp '   press "r" to run the selected stimulus'
disp '   press ESC to stop an ongoing stimulus (only while frames are flipping)'
disp '   press "q" to quit'
disp ' '
disp 'Now press any key when you are ready to blank the screen.'

pause
stims.core.run(menu, key)
end