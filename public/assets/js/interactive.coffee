# Interactive mode

class Dispatcher
  listeners = []

  register: (cmd) ->
    name = cmd.name?()

    throw "Command does not define a name" unless name

    console.info "Registering", name

    if listeners[name]?
      throw "Another listener has already registered command #{name}"
    if cmd instanceof Command
      listeners[name] = cmd

  dispatch: (pattern) ->
    input  = pattern.split /\s/ or []
    output = new ConsoleOutput()

    return unless input[0]

    if listeners[input[0]]?
      listeners[input[0]].run input, output, @
    else
      output.send "No command '#{input[0]}' found"

  getListeners: () -> listeners

class Runner
  constructor: () ->
    @setup()
    @question()

  answer: (answer) =>
    if answer == "exit"
      @close()
    else
      @dispatcher.dispatch answer
      @question()

  question: () ->
    throw "question() not implemented"

  setup: () =>
    @dispatcher = new Dispatcher(@.getOutputInterface());

    @dispatcher.register new HelpCommand()
    @dispatcher.register new WhoamiCommand()
    @dispatcher.register new UptimeCommand()

  getOutputInterface: () ->
    throw "getOutputInterface() not implemented"

class CliRunner extends Runner
  constructor: () ->
    readline = require('readline');
    @rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    })

    super

  question: () =>
    @rl.question("you@thatmattpattis.at:~$ ", @answer)

  close: () =>
    @rl.close()

  getOutputInterface: () -> new ReadlineOutput

class NullOutput
  send: () ->

class ConsoleOutput
  send: (text) ->
    console.log text

class ReadlineOutput
  constructor: (rl) ->
    @rl = rl
  send: (text) =>
    @rl.write text

class Command
  name: () ->

  help: (o) ->
    o.send "#{name()}"
    o.send "    #{description}"
    if @usage
      o.send ""
      o.send "USAGE:  #{usage}"

  run: () ->
    throw "run() method not implemented"

class HelpCommand extends Command
  name: () -> "help"

  run: (i, o, dispatcher) ->
    patterns = []
    for pattern, listener of dispatcher.getListeners()
      patterns.push pattern

    patterns.sort()
    for pattern in patterns
      o.send pattern

class WhoamiCommand extends Command
  name: () -> "whoami"

  run: (i, o) ->
    o.send "Matthew Patterson <matthew.s.patterson@gmail.com>"

class UptimeCommand extends Command
  name: () -> "uptime"

  run: (i, o) ->
    curr  = new Date
    birth = new Date("1988-04-26")

    years = months = days = 0

    while curr > birth
      switch
        when curr.getFullYear() > birth.getFullYear() and curr.getMonth() > birth.getMonth()
          years += 1
          curr.setYear(curr.getFullYear() - 1)
        when curr.getFullYear() > birth.getFullYear() and curr.getMonth() >= birth.getMonth() and curr.getDate() >= birth.getDate()
          years += 1
          curr.setYear(curr.getFullYear() - 1)
        when curr.getFullYear() > birth.getFullYear() and curr.getMonth() >= birth.getMonth()
          months += 1
          curr.setMonth(curr.getMonth() - 1)
        when curr.getFullYear() > birth.getFullYear() and curr.getMonth() < birth.getMonth()
          months += 1
          curr.setMonth(curr.getMonth() - 1)
        when curr.getMonth() > birth.getMonth() and curr.getDate() >= birth.getDate()
          months += 1
          curr.setMonth(curr.getMonth() - 1)
        when curr.getMonth() > birth.getMonth() and curr.getDate() < birth.getDate()
          days += 1
          curr.setDate(curr.getDate() - 1)
        when curr.getDate() > birth.getDate()
          days += 1
          curr.setDate(curr.getDate() - 1)

    o.send "#{years} years, #{months} months, #{days} days"

if module?.exports
  new CliRunner()
