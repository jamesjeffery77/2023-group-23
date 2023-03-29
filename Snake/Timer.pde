class Timer {
  /***
   *  Set how long it will time in the constructor.
   *
   *  Every new Timer will be pushed into the global
   *  varible 'timerList' automatically. There is a
   *  function 'refreshTimers()' which refreshes all
   *  Timers in each frame. 
   * 
   *  The timer will be deleted automatically at 0.1s 
   *  after the time is up.
   * 
   *  Use Timer.timeIsUp to know if the time is up.
   * 
   ***/

  long totalTime;
  long duration;
  long timestamp;
  boolean started = false;
  boolean timeIsUp = false;
  boolean canBeDeleted = false;

  Timer(float totalTime){ // [totalTime] is in seconds.
    this.totalTime = (long) (totalTime * 1000);
    this.duration = 0;
    this.timestamp = 0;
    timerList.add(this);
  }

  // Refresh the timer.
  // Return true when the time is up.
  void refresh(){ 
    long currentTime = millis();
    long timeDiff;
    if (!started){
      // Initalize the timestamp
      started = true;
      timestamp = currentTime;
      timeDiff = 0;
    } else{
      timeDiff = currentTime - timestamp; 
    }

    // Update the timestamp in each frame.
    timestamp = currentTime;
    if (gameState == GameState.PLAYING){
      // Update the duration only if not paused
      duration += timeDiff;  
    }
    timeIsUp = duration > totalTime;

    // At 0.1s after the time is up, the timer can be deleted.
    // The delete operation is that removing it from the timerList in fact.
    canBeDeleted = duration > totalTime + 100;
  }

  void reset(){
    started = false;
    timeIsUp = false;
    canBeDeleted = false;
    duration = 0;
  }
}
