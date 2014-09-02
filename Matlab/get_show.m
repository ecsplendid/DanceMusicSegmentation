function [this_show] = get_show(s, sampleRate)

    % note, shows is initialised from calling /data=set/local_testset.m
    % execute that before everything else. I'm sorry it has to be like this
    % for some reason executing it twice fails

    shows = get_allshows();
    
    this_show = shows{s};
    this_show.number = s;

    chops = this_show.chops;

    tic;

    this_show.audio = audioread( this_show.file );

    % some sanitization of the github test set file names
    showname = strrep(this_show.file, '_', ' ');
    showname = strrep(showname, 'examples/', '');
    showname = strrep(showname, '.wav', '');
    showname = strrep(showname, '01-', '');
    showname = strrep(showname, 'armin van buuren - ', '');
    showname = strrep(showname, ' - music for balearic people', '');
    showname = strrep(showname, 'Above and Beyond - ', '');
    showname = strrep(showname, ' (di.fm)', '');
    showname = strrep(showname, '-tt', '');
    showname = strrep(showname, '22-04-2010', '');
    showname = strrep(showname, '26-03-2010', '');
    
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
    clear chopper;
end