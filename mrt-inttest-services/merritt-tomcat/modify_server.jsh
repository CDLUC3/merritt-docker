String fname = "/tmp/server.xml";
String valve = "/tmp/valve.txt";
StringBuffer buf = new StringBuffer();
Files.lines(Paths.get(valve)).forEach(line -> {
  buf.append(line);
  buf.append("\n");
});

boolean bvalve = false;
Files.lines(Paths.get(fname)).forEach(line -> {
  if (line.matches(".*AccessLogValve.*")) {
    bvalve = true;
    System.out.println(buf.toString());
  }
  if (bvalve) {
    if (line.matches(".*\\/>")) {
      bvalve = false;
    }
  } else {
    System.out.println(line);
  }
});
/exit