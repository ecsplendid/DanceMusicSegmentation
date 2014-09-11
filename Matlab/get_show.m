function [this_show] = get_show(s, config)

    % note, shows is initialised from calling /data=set/local_testset.m
    % execute that before everything else. I'm sorry it has to be like this
    % for some reason executing it twice fails

    sampleRate = config.sampleRate;
    
    shows = get_allshows(config);
    
    this_show = shows{s};
    this_show.number = s;

    chops = this_show.chops;

    tic;

    this_show.audio = audioread( this_show.file );

    % some sanitization of the github test set file names
    showname = this_show.file;
    repl = '\d{2}-\d{2}-\d{4}|-tt|\.wav|01-|-|_|Above and Beyond|(di.fm)|music for balearic people|armin van buuren|roger shah';
    showname = regexprep(showname,'.+\\(?=[^\\]+$)','');
    showname = regexprep(showname, repl,'');
    showname = lower(showname);
    
    this_show.showname = showname;
    
    chopper =  true( size( this_show.audio ) ) ;

    % chop out the intros from the show
    for ch=1:size( chops, 1 )

        %get from and to in samples (stored in minutes)
        from = max(1,ceil(chops(ch,1)*sampleRate));
        to = ceil(chops(ch,2)*sampleRate);

        chopper( from:to ) = 0;
    end

    this_show.audio = this_show.audio(chopper);
end