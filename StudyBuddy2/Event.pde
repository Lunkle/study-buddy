class Event {
    String text;
    LocalDate date;
    Time time;
    Event(String text, LocalDate date, Time time) {
        this.text = text;
        this.date = date;
        this.time = time;
    }

    String toString() {
        return text + date;
    }
}

void loadEvents() {
    String[] eventDataRaw = loadStrings("Events.txt");
    Event[][] eventData = {};
    int index = 0;
    LocalDate lastDate = null;
    for (int i = 0; i < eventDataRaw.length; i++) {
        String[] eventRaw = eventDataRaw[i].split("//");
        LocalDate thisEventDate = LocalDate.parse(eventRaw[1]);
        Time thisEventTime = convertFromString(eventRaw[2]);
        Event thisEvent = new Event(eventRaw[0], thisEventDate, thisEventTime);
        try {
            if (thisEventDate.isAfter(lastDate)) {
                index += 1;
                eventData = (Event[][]) append(eventData, new Event[][]{});
                lastDate = thisEventDate;
            }
        }
        catch(Exception e) {
            eventData = (Event[][]) append(eventData, new Event[]{});
            lastDate = thisEventDate;
        }
        eventData[index] = (Event[]) append(eventData[index], thisEvent);
    }
    events = eventData;
}

void loadMonth() {
    month = new DayTile[today.lengthOfMonth()];
    for (int i = 0; i < 7; i++) {
        Label label = new Label(daysOfWeek[i], PADDING + i * (PADDING + WEEK_TILE_WIDTH), PADDING, WEEK_TILE_WIDTH, 30);
        calendarPanel.addComponent(label);
    }
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 7; j++) {
            DayTile tile = new DayTile(PADDING + j * (WEEK_TILE_WIDTH + PADDING), 2 * PADDING + 30 + i * (WEEK_TILE_HEIGHT + PADDING), today.plusDays(i), new Event[]{});
            calendarPanel.addComponent(tile);
        }
    }
}

void loadWeek() {
    //Initialize.
    for (int i = 0; i < 7; i++) {
        week[i] = new DayTile(PADDING + i * (WEEK_TILE_WIDTH + PADDING), PADDING, today.plusDays(i), new Event[]{}, weekPanel);
    }
    //Check if any new events.
    if (events[events.length - 1][0].date.isBefore(today)) {
        //If not, we're done here.
        return;
    }
    //Otherwise, find today.
    int index = 0;
    for (int i = 0; i < events.length; i++) {
        if (events[i][0].date.isAfter(today)) {
            index = i;
            break;
        }
    }
    //Calculate day one week from now.
    LocalDate oneWeekFromToday = today.plusDays(7);
    for (int i = index; i < min(events.length, index + 7); i++) {
        if (events[i][0].date.isAfter(oneWeekFromToday)) {
            return;
        }
        int daysInBetween = int(today.until(events[i][0].date, ChronoUnit.DAYS));
        //println(events[i][0]);
        week[daysInBetween].events = events[i];
    }
}
