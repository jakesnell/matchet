local matchet = require 'matchet.env'
require 'logroll'

function matchet.logformatter(level, msg)
   return string.format("[%s - %s] - %s\n", logroll.levels[level], os.date("%Y_%m_%d_%X"), msg)
end

function matchet.printLogger()
   return logroll.print_logger({
      formatter = utils.logformatter
   })
end

function matchet.addFileLogger(log, filename)
   return logroll.combine(log, logroll.file_logger(filename, { formatter = utils.logformatter }))
end
