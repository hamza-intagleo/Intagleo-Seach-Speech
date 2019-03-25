  //webkitURL is deprecated but nevertheless
  URL = window.URL || window.webkitURL;

  var gumStream;                      //stream from getUserMedia()
  var rec;                            //Recorder.js object
  var input;                          //MediaStreamAudioSourceNode we'll be recording

  // shim for AudioContext when it's not avb. 
  var AudioContext = window.AudioContext || window.webkitAudioContext;
  var audioContext //audio context to help us record



function toggleRecording( e ) {
  if (e.classList.contains("recording")) {
      // stop recording
      stopRecording();
      e.classList.remove("recording");
      $('#page-loader').show();
  } else {
    // start recording
    e.classList.add("recording");
    startRecording();
  }
}

function startRecording() {
    console.log("recordButton clicked");

    /*
        Simple constraints object, for more advanced audio features see
        https://addpipe.com/blog/audio-constraints-getusermedia/
    */
    
    constraints = { audio: true, video:false }

    /*
        Disable the record button until we get a success or fail from getUserMedia() 
    */
    // $("#recordButton").attr('disabled', true);
    // $("#stopButton").removeAttr('disabled');
    // $("#pauseButton").removeAttr('disabled');

    /*
        We're using the standard promise based getUserMedia() 
        https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
    */

    navigator.mediaDevices.getUserMedia(constraints).then(function(stream) {
        console.log("getUserMedia() success, stream created, initializing Recorder.js ...");

        /*
            create an audio context after getUserMedia is called
            sampleRate might change after getUserMedia is called, like it does on macOS when recording through AirPods
            the sampleRate defaults to the one set in your OS for your playback device

        */
        audioContext = new AudioContext();

        //update the format 
        $("#formats").innerHTML="Format: 1 channel pcm @ "+audioContext.sampleRate/1000+"kHz"

        /*  assign to gumStream for later use  */
        gumStream = stream;
        
        /* use the stream */
        input = audioContext.createMediaStreamSource(stream);

        /* 
            Create the Recorder object and configure to record mono sound (1 channel)
            Recording 2 channels  will double the file size
        */
        rec = new Recorder(input,{numChannels:1})

        //start the recording process
        rec.record()

        console.log("Recording started");

    }).catch(function(err) {
        //enable the record button if getUserMedia() fails
        // $("#recordButton").removeAttr('disabled');
        // $("#stopButton").attr('disabled', true);
        // $("#pauseButton").attr('disabled', true);
        alert('Please make sure to run application with https protocol')
    });
}

function pauseRecording(){
    console.log("pauseButton clicked rec.recording=",rec.recording );
    if (rec.recording){
        //pause
        rec.stop();
        $("#pauseButton").innerHTML="Resume";
    }else{
        //resume
        rec.record()
        $("#pauseButton").innerHTML="Pause";

    }
}

function stopRecording() {
    console.log("stopButton clicked");

    //disable the stop button, enable the record too allow for new recordings
    // $("#stopButton").attr('disabled', true);
    // $("#recordButton").removeAttr('disabled');
    // $("#pauseButton").attr('disabled', true);

    //reset button just in case the recording is stopped while paused
    $("#pauseButton").innerHTML="Pause";
    
    //tell the recorder to stop the recording
    rec.stop();

    //stop microphone access
    gumStream.getAudioTracks()[0].stop();

    //create the wav blob and pass it on to createDownloadLink
    rec.exportWAV(createDownloadLink);
}

function createDownloadLink(blob) {

  var reader  = new window.FileReader();
  reader.readAsDataURL(blob); 
  reader.onloadend = function() {
    var base64data = reader.result;
    var savedWAVBlob=base64data
    var site = $('#site_name').val();
    console.log(savedWAVBlob );
    data = new FormData(), 
    data.append("audio_url", savedWAVBlob)
    data.append("site", site)
    $('#search_data_table').html('')

    $.ajax({
      url: '/convert_audio_to_text_free',
      type: 'POST',
      data: data,
      contentType: false,
      processData: false,
      success: function(result) {
        if(result['results'][0] != undefined){
          $('#converted_text').val((result['results'][0].split(':')[1]));
          $('#speech_icon').addClass('d-none');
          $('#speech_submit').removeClass('d-none');
          // var api_data = '';
          // $.each(result['search_data'], function(key, val){
          //   api_data += '<tr>'
          //   api_data += '<td>'+val.title+'</td>'
          //   api_data += '<td><a href='+val.link+ '>'+val.link+'</a></td>'
          //   api_data += '/<tr>'
          // })
          // $('#search_data_table').append(api_data)
          $('#error_message').addClass('d-none')
        } else {
          $('#error_message').removeClass('d-none')
        }
        $('#page-loader').hide();
      }, 
      error: function(result) {
        alert(result['responseJSON']['message'])
        $('#page-loader').hide();
      }
    });
  }

  // var url = (window.URL || window.webkitURL).createObjectURL(blob);
  // var link = document.getElementById("save");
  // link.href = url;
  // link.download = filename || 'output.wav';
}