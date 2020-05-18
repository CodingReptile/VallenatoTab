import QtQuick 2.2
import MuseScore 3.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import FileIO 3.0
import QtQuick.Dialogs 1.2

MuseScore {

	property var loggingConfiguration:
	{
		"debug" : 1,
		"logToFile" : 1,
		"logToConsole" : 1,
		"fileName" : "VallenatoTab.debug",
	}

	onRun: {
		log ("testingLogger1")
		log ("testingLogger2")
		log ("testingLogger3")
	}

	// Debugging log
	FileIO {
			id: logger
			source: homePath() + "/" + loggingConfiguration.fileName
			onError: console.log(msg)
	}

	// Log data
	function log(data){

		if (loggingConfiguration.debug == 1)
		{
			if (loggingConfiguration.logToConsole == 1)
			{
				console.log(data)
			}
			
			if (loggingConfiguration.logToFile == 1)
			{
				console.log(logger.source)
				// TODO: There's no append method.  So we need to read all file then append single line.
				// Big perf issue here
				
				if (logger.exists())
				{				
					var currentContent = logger.read()
					currentContent = currentContent.trim()
					data = currentContent + "\r\n" + data;
				}
				
				logger.write(data)
			}
		}		
	}

	description: qsTr("Tablatures for diatonic accordions")

	menuPath: "Plugins.VallenatoTab.Tablature"
	requiresScore: true
	version: "1.00"
	pluginType: "dialog"
}
