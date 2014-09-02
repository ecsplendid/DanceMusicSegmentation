function [indexes, audio_low, showname] = get_show(s, sampleRate)

    % note, shows is initialised from calling /data=set/local_testset.m
    % execute that before everything else. I'm sorry it has to be like this
    % for some reason executing it twice fails

    shows = get_allshows();
    
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