import QtQuick 2.3
import MuseScore 3.0
import QtQuick.Controls 1.5
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import FileIO 3.0
import QtQuick.Dialogs 1.2

MuseScore {

    id : vallenatoTab

    property var loggingConfiguration:
    {
        "debug" : true,
        "logToFile" : true,
        "logToConsole" : true,
        "fileName" : "VallenatoTab.debug",
    }

    onRun: {
        initialize()
    }

    // Initializes all plugin data structures
    function initialize()
    {
        buildButtonToUIMapping()
    }

    // Debugging log
    FileIO {
            id: logger
            source: homePath() + "/" + loggingConfiguration.fileName
            onError: console.log(msg)
    }

    // Log data
    function log(data){

        if (loggingConfiguration.debug)
        {
            if (loggingConfiguration.logToConsole)
            {
                console.log(data)
            }

            if (loggingConfiguration.logToFile)
            {
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

    width: 500
    height: 600

    description: qsTr("Tablatures for diatonic accordions")

    menuPath: "Plugins.VallenatoTab.Tablature"
    requiresScore: true
    version: "1.00"
    pluginType: "dialog"

    // Here we start composing the UI
    GridLayout {
        id: mainGrid
        columns: 3
        anchors.fill: parent
        anchors.margins: 10

        width : parent.width
        height : parent.height

        Label {
            text: qsTr("Tablature for Diatonic Accordion")
            font.bold : true
            font.pointSize : 13
            horizontalAlignment : Text.AlignHCenter

            Layout.columnSpan: 3
            Layout.fillWidth : true
        }

        // Accordion configuration
        GroupBox {
            title: qsTr("Accordion configuration")
            width : parent.width

            Layout.columnSpan: 3
            Layout.fillWidth : true

            RowLayout {
                id: accordionGrid
                //columns: 3
                width : parent.width
                height : parent.height

                anchors.fill: parent

                Label {
                    text: qsTr("Accordion selected")
                }

                Text {
                    text : "<None>"
                }

                Button {
                    text: qsTr("Configure")
                    onClicked : {
                        log ("Configuring accordion")
                        accordionConfiguration.open()
                    }
                }
            }
        }

        // Accept parameters and run
        RowLayout {

            Layout.columnSpan: 3
            Layout.fillWidth : true
            Layout.alignment: Qt.AlignCenter

            Button {
                text: qsTr("Run")
                onClicked : {
                }
            }

            Button {
                text: qsTr("Cancel")
            }
        }
    }

    Dialog {
        id: accordionConfiguration
        visible: false
        title: "Configure accordion"
        standardButtons: StandardButton.Ok | StandardButton.Cancel

        ColumnLayout{
            spacing : 3

            GroupBox {
                id : accordionFileGroupBox
                title: qsTr("Load/Save configuration")
                property int columnWidth : 50

                RowLayout
                {
                    Label {
                        text : qsTr("Configuration file")
                        horizontalAlignment :  Text.AlignLeft
                        width : accordionFileGroupBox.columnWidth
                    }

                    Label {
                        id : selectedAccordionFile
                        text : qsTr("")
                        horizontalAlignment :  Text.AlignHCenter
                        width : accordionFileGroupBox.columnWidth
                    }

                    Button
                    {
                        text: qsTr("Load")
                        width : accordionFileGroupBox.columnWidth
                        onClicked : {
                            log ("Load accordion configuration")
                        }
                    }

                    Button
                    {
                        text: qsTr("Save")
                        width : accordionFileGroupBox.columnWidth
                        onClicked : {
                            log ("Save accordion configuration")
                        }
                    }
                }
            }

            Label {
                text : qsTr("")
                horizontalAlignment :  Text.AlignHCenter
                Layout.preferredWidth: parent.width
            }

            RowLayout
            {
                id : accordionRow
                property int columnWidth : 30


                GroupBox {
                    id : openingAccordionLayoutGroupBox
                    title: qsTr("Opening")

                    GridLayout {
                        id: grid
                        columns: 8

                        // General description
                        Label {
                            text : qsTr("Right hand")
                            horizontalAlignment :  Text.AlignHCenter

                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }

                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }

                        Label {
                            text : qsTr("Left hand")
                            horizontalAlignment :  Text.AlignHCenter

                            Layout.columnSpan: 2
                            Layout.preferredWidth: accordionRow.columnWidth * 2
                        }

                        // Rows descriptions
                        Label {
                            text : qsTr("Col 1")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Col 2")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Col 3")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Bass 2")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Bass 1")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 1
                        TextField {
                            id : o_r_1_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }
                            
                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_1_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_1_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 2
                        TextField {
                            id : o_r_2_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_2_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_2_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 3
                        TextField {
                            id : o_r_3_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_3_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_3_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_1_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }
                            
                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_1_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 4
                        TextField {
                            id : o_r_4_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_4_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_4_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_2_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_2_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 5
                        TextField {
                            id : o_r_5_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_5_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_5_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_3_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_3_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 6
                        TextField {
                            id : o_r_6_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_6_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_6_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_4_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_4_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 7
                        TextField {
                            id : o_r_7_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_7_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_7_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_5_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_5_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 8
                        TextField {
                            id : o_r_8_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_8_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_8_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : o_l_6_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_6_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 9
                        TextField {
                            id : o_r_9_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_9_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_9_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 10
                        TextField {
                            id : o_r_10_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_10_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_10_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 11
                        TextField {
                            id : o_r_11_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_11_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_11_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }
                    }
                }

                GroupBox {
                    id : closingaccordionRow
                    title: qsTr("Closing")
                    property int columnWidth : 30

                    GridLayout {
                        columns: 8

                        // General description
                        Label {
                            text : qsTr("Right hand")
                            horizontalAlignment :  Text.AlignHCenter

                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }

                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }

                        Label {
                            text : qsTr("Left hand")
                            horizontalAlignment :  Text.AlignHCenter

                            Layout.columnSpan: 2
                            Layout.preferredWidth: accordionRow.columnWidth * 2
                        }

                        // Rows descriptions
                        Label {
                            text : qsTr("Col 1")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Col 2")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Col 3")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Bass 2")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        Label {
                            text : qsTr("Bass 1")
                            horizontalAlignment :  Text.AlignLeft

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 1
                        TextField {
                            id : c_r_1_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_1_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_1_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 2
                        TextField {
                            id : c_r_2_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_2_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_2_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 3
                        TextField {
                            id : c_r_3_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_3_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_3_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_1_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_1_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 4
                        TextField {
                            id : c_r_4_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_4_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_4_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_2_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_2_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 5
                        TextField {
                            id : c_r_5_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_5_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_5_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_3_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_3_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 6
                        TextField {
                            id : c_r_6_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_6_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_6_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_4_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_4_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 7
                        TextField {
                            id : c_r_7_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_7_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_7_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_5_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_5_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 8
                        TextField {
                            id : c_r_8_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_8_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_8_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 3
                            Layout.preferredWidth: accordionRow.columnWidth * 3
                        }
                        TextField {
                            id : c_l_6_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_6_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 9
                        TextField {
                            id : c_r_9_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_9_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_9_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 10
                        TextField {
                            id : c_r_10_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_10_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_10_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }

                        // Row 11
                        TextField {
                            id : c_r_11_1
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_11_2
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_11_3
                            maximumLength : 4
                            validator: RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        Label {
                            Layout.columnSpan: 5
                            Layout.preferredWidth: accordionRow.columnWidth * 5
                        }
                    }
                }
            }
        }

        onAccepted :
        {
            log ("Clicked in ok")
            validateConfiguration()
        }

        function validateConfiguration()
        {
            validateInputRightHand()
            validateInputLeftHand()
        }

        onRejected :
        {
            log ("Clicked in cancel")
            close()
        }

        function buildButtonMapping()
        {
        }
    }

    // Mapping between a note and the accordion button
    property var notesToButtonMapping: {}

    // Mapping between the accordion button and the UI element
    // If more UI element are added to the accordion, this mapping should also
    // be updated
    property var rightHandUIButtonMapping: {}
    property var leftHandUIButtonMapping: {}

    // Builds a mapping between button names and it's UI counterparts.
    //
    // I don't generally like having to build this structure, because ideally we should
    // be able to access UI elements by crafting their id programatically
    // but could not find a way to achieve that in QML
    function buildButtonToUIMapping()
    {
        rightHandUIButtonMapping = {}

        // Opening positions

        // Right hand, Column 1
        rightHandUIButtonMapping["o_1"] = o_r_1_1
        rightHandUIButtonMapping["o_2"] = o_r_2_1
        rightHandUIButtonMapping["o_3"] = o_r_3_1
        rightHandUIButtonMapping["o_4"] = o_r_4_1
        rightHandUIButtonMapping["o_5"] = o_r_5_1
        rightHandUIButtonMapping["o_6"] = o_r_6_1
        rightHandUIButtonMapping["o_7"] = o_r_7_1
        rightHandUIButtonMapping["o_8"] = o_r_8_1
        rightHandUIButtonMapping["o_9"] = o_r_9_1
        rightHandUIButtonMapping["o_10"] = o_r_10_1
        rightHandUIButtonMapping["o_11"] = o_r_11_1

        // Right hand, Column 2
        rightHandUIButtonMapping["o_1'"] = o_r_1_2
        rightHandUIButtonMapping["o_2'"] = o_r_2_2
        rightHandUIButtonMapping["o_3'"] = o_r_3_2
        rightHandUIButtonMapping["o_4'"] = o_r_4_2
        rightHandUIButtonMapping["o_5'"] = o_r_5_2
        rightHandUIButtonMapping["o_6'"] = o_r_6_2
        rightHandUIButtonMapping["o_7'"] = o_r_7_2
        rightHandUIButtonMapping["o_8'"] = o_r_8_2
        rightHandUIButtonMapping["o_9'"] = o_r_9_2
        rightHandUIButtonMapping["o_10'"] = o_r_10_2
        rightHandUIButtonMapping["o_11'"] = o_r_11_2

        // Right hand, Column 3
        rightHandUIButtonMapping["o_1''"] = o_r_1_3
        rightHandUIButtonMapping["o_2''"] = o_r_2_3
        rightHandUIButtonMapping["o_3''"] = o_r_3_3
        rightHandUIButtonMapping["o_4''"] = o_r_4_3
        rightHandUIButtonMapping["o_5''"] = o_r_5_3
        rightHandUIButtonMapping["o_6''"] = o_r_6_3
        rightHandUIButtonMapping["o_7''"] = o_r_7_3
        rightHandUIButtonMapping["o_8''"] = o_r_8_3
        rightHandUIButtonMapping["o_9''"] = o_r_9_3
        rightHandUIButtonMapping["o_10''"] = o_r_10_3
        rightHandUIButtonMapping["o_11''"] = o_r_11_3

        // Closing positions

        // Right hand, Column 1
        rightHandUIButtonMapping["c_1"] = c_r_1_1
        rightHandUIButtonMapping["c_2"] = c_r_2_1
        rightHandUIButtonMapping["c_3"] = c_r_3_1
        rightHandUIButtonMapping["c_4"] = c_r_4_1
        rightHandUIButtonMapping["c_5"] = c_r_5_1
        rightHandUIButtonMapping["c_6"] = c_r_6_1
        rightHandUIButtonMapping["c_7"] = c_r_7_1
        rightHandUIButtonMapping["c_8"] = c_r_8_1
        rightHandUIButtonMapping["c_9"] = c_r_9_1
        rightHandUIButtonMapping["c_10"] = c_r_10_1
        rightHandUIButtonMapping["c_11"] = c_r_11_1

        // Right hand, Column 2
        rightHandUIButtonMapping["c_1'"] = c_r_1_2
        rightHandUIButtonMapping["c_2'"] = c_r_2_2
        rightHandUIButtonMapping["c_3'"] = c_r_3_2
        rightHandUIButtonMapping["c_4'"] = c_r_4_2
        rightHandUIButtonMapping["c_5'"] = c_r_5_2
        rightHandUIButtonMapping["c_6'"] = c_r_6_2
        rightHandUIButtonMapping["c_7'"] = c_r_7_2
        rightHandUIButtonMapping["c_8'"] = c_r_8_2
        rightHandUIButtonMapping["c_9'"] = c_r_9_2
        rightHandUIButtonMapping["c_10'"] = c_r_10_2
        rightHandUIButtonMapping["c_11'"] = c_r_11_2

        // Right hand, Column 3
        rightHandUIButtonMapping["c_1''"] = c_r_1_3
        rightHandUIButtonMapping["c_2''"] = c_r_2_3
        rightHandUIButtonMapping["c_3''"] = c_r_3_3
        rightHandUIButtonMapping["c_4''"] = c_r_4_3
        rightHandUIButtonMapping["c_5''"] = c_r_5_3
        rightHandUIButtonMapping["c_6''"] = c_r_6_3
        rightHandUIButtonMapping["c_7''"] = c_r_7_3
        rightHandUIButtonMapping["c_8''"] = c_r_8_3
        rightHandUIButtonMapping["c_9''"] = c_r_9_3
        rightHandUIButtonMapping["c_10''"] = c_r_10_3
        rightHandUIButtonMapping["c_11''"] = c_r_11_3

        leftHandUIButtonMapping = {}

        // Opening positions

        // Left hand, Column 1
        leftHandUIButtonMapping["o_l1"] = o_l_1_1
        leftHandUIButtonMapping["o_l2"] = o_l_2_1
        leftHandUIButtonMapping["o_l3"] = o_l_2_1
        leftHandUIButtonMapping["o_l4"] = o_l_4_1
        leftHandUIButtonMapping["o_l5"] = o_l_5_1
        leftHandUIButtonMapping["o_l6"] = o_l_6_1

        // Left hand, Column 2
        leftHandUIButtonMapping["o_l1'"] = o_l_1_2
        leftHandUIButtonMapping["o_l2'"] = o_l_2_2
        leftHandUIButtonMapping["o_l3'"] = o_l_2_2
        leftHandUIButtonMapping["o_l4'"] = o_l_4_2
        leftHandUIButtonMapping["o_l5'"] = o_l_5_2
        leftHandUIButtonMapping["o_l6'"] = o_l_6_2

        // Closing positions

        // Left hand, Column 1
        leftHandUIButtonMapping["c_l1"] = c_l_1_1
        leftHandUIButtonMapping["c_l2"] = c_l_2_1
        leftHandUIButtonMapping["c_l3"] = c_l_2_1
        leftHandUIButtonMapping["c_l4"] = c_l_4_1
        leftHandUIButtonMapping["c_l5"] = c_l_5_1
        leftHandUIButtonMapping["c_l6"] = c_l_6_1

        // Left hand, Column 2
        leftHandUIButtonMapping["c_l1'"] = c_l_1_2
        leftHandUIButtonMapping["c_l2'"] = c_l_2_2
        leftHandUIButtonMapping["c_l3'"] = c_l_2_2
        leftHandUIButtonMapping["c_l4'"] = c_l_4_2
        leftHandUIButtonMapping["c_l5'"] = c_l_5_2
        leftHandUIButtonMapping["c_l6'"] = c_l_6_2
    }

    // Validates that all right hand notes are valid
    function validateInputRightHand()
    {
        for (var key in rightHandUIButtonMapping)
        {
            rightHandUIButtonMapping[key].textColor = "#000000"
            rightHandUIButtonMapping[key].text = rightHandUIButtonMapping[key].text.trim()

            var note = rightHandUIButtonMapping[key].text

            if (validateRightHandNote(note))
            {
                continue
            }

            rightHandUIButtonMapping[key].textColor = "#FF0000"
            log ( "note: '" + note + "' is invalid" )
        }
    }

    function validateRightHandNote(note)
    {
        var regEx = /^[a-gA-G][#bB]?[0-9]$/g

        // Empty note is valid
        if (note == "")
        {
            return true
        }

        // Find matches, expect exactly one
        var matches = note.match(regEx)
        if (matches != null && matches.length == 1)
        {
            return true
        }

        return false
    }

    // Validates that all right hand notes are valid
    function validateInputLeftHand()
    {
        for (var key in leftHandUIButtonMapping)
        {
            // Do some cleanup first
            leftHandUIButtonMapping[key].textColor = "#000000"
            leftHandUIButtonMapping[key].text = leftHandUIButtonMapping[key].text.trim()

            var note = leftHandUIButtonMapping[key].text

            if (validateLeftHandNote(note))
            {
                continue
            }

            leftHandUIButtonMapping[key].textColor = "#FF0000"
            log ( "note: '" + note + "' is invalid" )
        }
    }

    function validateLeftHandNote(note)
    {
        var regEx = /^[a-gA-G][#bB]?[mM]?$/g

        // Empty note is valid
        if (note == "")
        {
            return true
        }

        // Find matches, expect exactly one
        var matches = note.match(regEx)
        if (matches != null && matches.length == 1)
        {
            return true
        }

        return false
    }
}
