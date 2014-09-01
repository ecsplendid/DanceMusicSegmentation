function [indexes, audio_low, showname] = get_show(s, sampleRate)

    % note, shows is initialised from calling /data=set/local_testset.m
    % execute that before everything else. I'm sorry it has to be like this
    % for some reason executing it twice fails
    
    shows = { show('./examples/01-armin_van_buuren_-_a_state_of_trance_453_(di.fm)_22-04-2010-tt.wav','./examples/01-armin_van_buuren_-_a_state_of_trance_453_(di.fm)_22-04-2010-tt.ind.txt','./examples/01-armin_van_buuren_-_a_state_of_trance_453_(di.fm)_22-04-2010-tt.chops.txt'),...
        show('./examples/01-armin_van_buuren_-_a_state_of_trance_462_(di.fm)_24-06-2010-tt.wav','./examples/01-armin_van_buuren_-_a_state_of_trance_462_(di.fm)_24-06-2010-tt.ind.txt','./examples/01-armin_van_buuren_-_a_state_of_trance_462_(di.fm)_24-06-2010-tt.chops.txt'),...
        show('./examples/01-roger_shah_magic_island_-_music_for_balearic_people_098_(di.fm)_26-03-2010-tt.wav','./examples/01-roger_shah_magic_island_-_music_for_balearic_people_098_(di.fm)_26-03-2010-tt.ind.txt','./examples/01-roger_shah_magic_island_-_music_for_balearic_people_098_(di.fm)_26-03-2010-tt.chops.txt'),...
        show('./examples/01-roger_shah_magic_island_-_music_for_balearic_people_112_(di.fm)_02-07-2010-tt.wav','./examples/01-roger_shah_magic_island_-_music_for_balearic_people_112_(di.fm)_02-07-2010-tt.ind.txt','./examples/01-roger_shah_magic_island_-_music_for_balearic_people_112_(di.fm)_02-07-2010-tt.chops.txt'),...
        show('./examples/Above_and_Beyond_-_Trance_Around_the_World_364.wav','./examples/Above_and_Beyond_-_Trance_Around_the_World_364.ind.txt','./examples/Above_and_Beyond_-_Trance_Around_the_World_364.chops.txt'),...
        show('./examples/Above_and_Beyond_-_Trance_Around_the_World_372.wav','./examples/Above_and_Beyond_-_Trance_Around_the_World_372.ind.txt','./examples/Above_and_Beyond_-_Trance_Around_the_World_372.chops.txt'),...
        };
    
    this_show = shows{s};

    indexes = this_show.indexes; 
    chops = this_show.chops;

    tic;

    audio_low = audioread( this_show.file );

    showname = strrep(this_show.file, '_', ' ');
    showname = strrep(showname, 'examples/', '');
    showname = strrep(showname, '.wav', '');

    chopper =  true( size( audio_low ) ) ;

    % chop out the intros from the show
    for ch=1:size( chops, 1 )

        %get from and to in samples (stored in minutes)
        from = max(1,ceil(chops(ch,1)*sampleRate));
        to = ceil(chops(ch,2)*sampleRate);

        chopper( from:to ) = 0;
    end

    audio_low = audio_low(chopper);
    clear chopper;
end