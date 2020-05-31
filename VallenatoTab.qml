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
        "logToFile" : false,
        "logToConsole" : true,
        "fileName" : "VallenatoTab.debug",
    }

    // Mappings between a note and all the accordion positions
    property var rightHand_notesToButtonMapping: {}
    property var leftHand_notesToButtonMapping: {}

    // Mapping between the accordion button and the UI element
    // If more UI element are added to the accordion, this mapping should also
    // be updated
    property var rightHandUIButtonMapping: {}
    property var leftHandUIButtonMapping: {}

    onRun: {
        initialize()
    }

    // Initializes all plugin data structures
    function initialize()
    {
        // Configure UI
        buildButtonToUIMapping()

        // Build data structures
        buildNoteMappings()
    }

    function buildNoteMappings()
    {
        rightHand_notesToButtonMapping = {}

        for (var key in rightHandUIButtonMapping)
        {
            var currentNote = rightHandUIButtonMapping[key].text

            if (validateRightHandNote(currentNote) && currentNote != "")
            {
                //currentNote = convertRightHandNoteToProperNotation(currentNote)

                //if (rightHand_notesToButtonMapping[currentNote] == null)
                //{
                //    rightHand_notesToButtonMapping[currentNote] = []
                //}

                //rightHand_notesToButtonMapping[currentNote].push(key)

                var museScorePitch = convertRightHandNoteToMuseScorePitch(currentNote)
                if (rightHand_notesToButtonMapping[museScorePitch] == null)
                {
                    rightHand_notesToButtonMapping[museScorePitch] = []
                }

                rightHand_notesToButtonMapping[museScorePitch].push(key)
            }
        }

        leftHand_notesToButtonMapping = {}

        for (var key in leftHandUIButtonMapping)
        {
            var currentNote = leftHandUIButtonMapping[key].text

            if (validateLeftHandNote(currentNote) && currentNote != "")
            {
                if (leftHand_notesToButtonMapping[currentNote] == null)
                {
                    leftHand_notesToButtonMapping[currentNote] = []
                }

                leftHand_notesToButtonMapping[currentNote].push(key)
            }
        }

        // DEBUG

        /*
        for (var key in rightHand_notesToButtonMapping)
        {
            var notes = rightHand_notesToButtonMapping[key]

            var allNotes = ""
            for (var i=0; i<notes.length; i++)
            {
                if (i === 0)
                {
                    allNotes += notes[i]
                }
                else
                {
                    allNotes += ", " + notes[i]
                }
            }

            log ("note: '" + key + "': " + allNotes)
        }

        for (var key in leftHand_notesToButtonMapping)
        {
            var notes = leftHand_notesToButtonMapping[key]

            var allNotes = ""
            for (var i=0; i<notes.length; i++)
            {
                if (i === 0)
                {
                    allNotes += notes[i]
                }
                else
                {
                    allNotes += ", " + notes[i]
                }
            }

            log ("bass note: '" + key + "': " + allNotes)
        }

        */
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
                width : parent.width
                height : parent.height

                anchors.fill: parent

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
                    createTablature(curScore)
                }
            }

            Button {
                text: qsTr("Cancel")
                onClicked : {
                    Qt.quit()
                }
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
                width : 300

                Layout.fillWidth : true

                RowLayout
                {
                    Layout.fillWidth : true

                    Button
                    {
                        text: qsTr("Load")
                        onClicked : {
                            log ("Load accordion configuration")

                            fileLoadAccordion.open()
                        }
                    }

                    Label {
                        text : qsTr("")
                        horizontalAlignment :  Text.AlignHCenter
                        Layout.preferredWidth: 30
                    }

                    Text {
                        id : selectedAccordionFile
                        text : qsTr("")
                        horizontalAlignment :  Text.AlignHCenter
                        font.bold : true
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

                Layout.fillWidth : true

                GroupBox {
                    id : closingaccordionRow
                    title: qsTr("Closing")
                    property int columnWidth : 30

                    Layout.fillWidth : true

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_1_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_1_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_2_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_2_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_3_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_3_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_1_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 4
                        TextField {
                            id : c_r_4_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_4_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_4_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_2_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 5
                        TextField {
                            id : c_r_5_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_5_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_5_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_3_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 6
                        TextField {
                            id : c_r_6_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_6_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_6_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_4_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 7
                        TextField {
                            id : c_r_7_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_7_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_7_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_5_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 8
                        TextField {
                            id : c_r_8_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_8_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_8_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_l_6_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 9
                        TextField {
                            id : c_r_9_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_9_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_9_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_10_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_10_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_11_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : c_r_11_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                    id : openingAccordionLayoutGroupBox
                    title: qsTr("Opening")

                    Layout.fillWidth : true

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
                            validator: rightHandButtonValidator
                            /*onEditingFinished : {
                                log ("onEditingFinished triggered")

                                accordionConfiguration.validateConfiguration()
                            }*/

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_1_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_1_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_2_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_2_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_3_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_3_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_1_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 4
                        TextField {
                            id : o_r_4_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_4_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_4_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_2_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 5
                        TextField {
                            id : o_r_5_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_5_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_5_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_3_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 6
                        TextField {
                            id : o_r_6_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_6_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_6_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_4_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 7
                        TextField {
                            id : o_r_7_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_7_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_7_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_5_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 8
                        TextField {
                            id : o_r_8_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_8_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_8_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_l_6_1
                            maximumLength : 4
                            validator: leftHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }

                        // Row 9
                        TextField {
                            id : o_r_9_1
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_9_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_9_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_10_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_10_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_11_2
                            maximumLength : 4
                            validator: rightHandButtonValidator

                            Layout.columnSpan: 1
                            Layout.preferredWidth: accordionRow.columnWidth
                        }
                        TextField {
                            id : o_r_11_3
                            maximumLength : 4
                            validator: rightHandButtonValidator

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
            validateConfiguration()

            buildNoteMappings()
        }

        function validateConfiguration()
        {
            validateInputRightHand()
            validateInputLeftHand()
        }

        onRejected :
        {
            close()
        }

        FileIO {
            id: accordionConfigurationFile
            onError: console.log(msg)
        }

        FileDialog {
            id: fileLoadAccordion
            title: qsTr("Load accordion file")
            folder: shortcuts.documents + "/MuseScore3/plugins/VallenatoTab/accordions/"
            nameFilters: [ "Accordion (*.accordion)", "All files (*)" ]
            selectedNameFilter: "Accordion (*.accordion)"
            selectExisting: true
            selectFolder: false
            selectMultiple: false
            onAccepted: {
                log ("Load " + fileUrl)

                if (fileUrl.toString().indexOf("file:///") != -1)
                {
                    accordionConfigurationFile.source = fileUrl.toString().substring(fileUrl.toString().charAt(9) === ':' ? 8 : 7)
                }
                else
                {
                    accordionConfigurationFile.source = fileUrl
                }

                log ( "source: " + accordionConfigurationFile.source )

                var configuration = JSON.parse(accordionConfigurationFile.read())
                loadConfiguration(configuration.buttonMapping)

                selectedAccordionFile.text = configuration.name

            }

            onRejected: {
                Qt.quit()
            }
          }
    }

    function loadConfiguration(configuration)
    {
        for (var key in rightHandUIButtonMapping)
        {
            var note = configuration[key]
            if (note != null && validateRightHandNote(note))
            {
                var standardNote = convertRightHandNoteToProperNotation(note)
                rightHandUIButtonMapping[key].text = standardNote
            }
        }

        for (var key in leftHandUIButtonMapping)
        {
            var note = configuration[key]
            if (note != null && validateLeftHandNote(note))
            {
                leftHandUIButtonMapping[key].text = note
            }
        }
    }

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
        leftHandUIButtonMapping["o_l3"] = o_l_3_1
        leftHandUIButtonMapping["o_l4"] = o_l_4_1
        leftHandUIButtonMapping["o_l5"] = o_l_5_1
        leftHandUIButtonMapping["o_l6"] = o_l_6_1

        // Left hand, Column 2
        leftHandUIButtonMapping["o_l1'"] = o_l_1_2
        leftHandUIButtonMapping["o_l2'"] = o_l_2_2
        leftHandUIButtonMapping["o_l3'"] = o_l_3_2
        leftHandUIButtonMapping["o_l4'"] = o_l_4_2
        leftHandUIButtonMapping["o_l5'"] = o_l_5_2
        leftHandUIButtonMapping["o_l6'"] = o_l_6_2

        // Closing positions

        // Left hand, Column 1
        leftHandUIButtonMapping["c_l1"] = c_l_1_1
        leftHandUIButtonMapping["c_l2"] = c_l_2_1
        leftHandUIButtonMapping["c_l3"] = c_l_3_1
        leftHandUIButtonMapping["c_l4"] = c_l_4_1
        leftHandUIButtonMapping["c_l5"] = c_l_5_1
        leftHandUIButtonMapping["c_l6"] = c_l_6_1

        // Left hand, Column 2
        leftHandUIButtonMapping["c_l1'"] = c_l_1_2
        leftHandUIButtonMapping["c_l2'"] = c_l_2_2
        leftHandUIButtonMapping["c_l3'"] = c_l_3_2
        leftHandUIButtonMapping["c_l4'"] = c_l_4_2
        leftHandUIButtonMapping["c_l5'"] = c_l_5_2
        leftHandUIButtonMapping["c_l6'"] = c_l_6_2
    }

    property var rightHandButtonValidator : RegExpValidator { regExp: /^[a-gA-G][#bB]?[0-9]$/g }
    property var leftHandButtonValidator : RegExpValidator { regExp: /^[a-gA-G][#bB]?[mM]?$/g }

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
                var standardNote = convertRightHandNoteToProperNotation(note)
                rightHandUIButtonMapping[key].text = standardNote
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
        if (note === "")
        {
            return true
        }

        // Find matches, expect exactly one
        var matches = note.match(regEx)
        if (matches != null && matches.length === 1)
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
        if (note === "")
        {
            return true
        }

        // Find matches, expect exactly one
        var matches = note.match(regEx)
        if (matches != null && matches.length === 1)
        {
            return true
        }

        return false
    }

    // From the accordion configuration, build the notes mapping
    function convertRightHandNoteToProperNotation(note)
    {
        // Precondition: the note passes validation of validateRightHandNote

        if (note === "")
        {
            return note
        }

        note = note.charAt(0).toUpperCase() + note.charAt(1).toLowerCase() + note.slice(2)

        return note
    }

    // From the accordion configuration, build the notes mapping
    function convertRightHandNoteToMuseScorePitch(note)
    {
        // Extract note
        var noteRegEx = /^[a-gA-G][#bB]?/g

        var matches = note.match(noteRegEx)
        if (matches == null || matches.length != 1)
        {
            log ("Error parsing note of " + note)
            return
        }

        var baseNote = stringNoteToBaseMusescoreNote(matches[0])
        if (baseNote === -1)
        {
            log ("Error converting to base musescore pitch of " + note)
            return
        }

        var octaveRegex = /[0-9]$/g
        matches = note.match(octaveRegex)
        if (matches == null || matches.length != 1)
        {
            log ("Error parsing octave of " + note)
            return
        }

        var octave = parseInt(matches[0])

        return (octave + 1) * 12 + baseNote
    }

    function stringNoteToBaseMusescoreNote(note)
    {
        switch (note.toLowerCase())
        {
            case 'c':
                return 0
            case 'c#':
            case 'db':
                return 1
            case 'd':
                return 2
            case 'd#':
            case 'eb':
                return 3
            case 'e':
                return 4
            case 'f':
                return 5
            case 'f#':
            case 'gb':
                return 6
            case 'g':
                return 7
            case 'g#':
            case 'ab':
                return 8
            case 'a':
                return 9
            case 'a#':
            case 'bb':
                return 10
            case 'b':
                return 11
        }

        return -1
    }

    // Traverse score and build tablature for it
    function createTablature(score)
    {
        var cursor = score.newCursor()

        // If only a segment was selected, only act on that section
        if (cursor.segment)
        {
            cursor.rewind(Cursor.SELECTION_START)
        }
        else
        {
            cursor.rewind(Cursor.SCORE_START)
        }

        do
        {
            if (cursor.element.type == Element.CHORD)
            {
                var buttonCombinations = []
                
                var chord = cursor.element.notes
                var numCombinations = 1
                for (var i=0; i < chord.length; i++)
                {
                    var pitch = chord[i].pitch

                    // See if we have a matching pitch in our accordion
                    if (rightHand_notesToButtonMapping[pitch] != null)
                    {
                        buttonCombinations[i] = rightHand_notesToButtonMapping[pitch]
                    }
                    else
                    {
                        buttonCombinations[i] = []
                        buttonCombinations[i].push("?")
                    }

                    numCombinations *= buttonCombinations[i].length
                }

                // Build all combinations
                var allCombinations = []
                for (var i=0; i < numCombinations; i++)
                {
                    allCombinations[i] = []
                    for (var j = 0; j < chord.length; j++)
                    {
                        var multiplier = 1
                        for (var k=j+1; k < chord.length; k++)
                        {
                            multiplier *= buttonCombinations[k].length
                        }

                        var pos = Math.floor(i / multiplier) % buttonCombinations[j].length
                        allCombinations[i].push(buttonCombinations[j][pos])
                    }
                }

                log ("All possible combinations for the chord: " + numCombinations)
                for (var i=0; i < allCombinations.length; i++)
                {
                    var combination = ""
                    for (var j=0; j < allCombinations[i].length; j++)
                    {
                        if (j > 0)
                        {
                            combination += ","
                        }

                        combination +=  allCombinations[i][j]
                        
                    }

                    log (combination)
                }
                    
                /*var closingTab = newElement(Element.LYRICS)
                var openingTab = newElement(Element.LYRICS)
                
                var addClosingTab = true
                var addOpeningTab = true
                
                if (buttonsClosing.length == 0 && buttonsOpening.length == 0)
                {
                    addOpeningTab = false
                    closingTab.text = "?"
                    openingTab.text = ""
                }
                else
                {
                    addOpeningTab = buttonsOpening.length != 0
                    addClosingTab
 = buttonsClosing.length != 0
                    closingTab.text = buttonsClosing.join(',')
                    openingTab.text = buttonsOpening.join(',')
                }
                
                closingTab.offsetY = 3
                closingTab.verse = 0
                closingTab.autoplace = false
                
                openingTab.offsetY = 6
                openingTab.verse = 1
                openingTab.autoplace = false
                
                if (addClosingTab) {
                    cursor.add (closingTab)
                }
                
                if (addOpeningTab) {
                    cursor.add (openingTab) 
                }   */                 
            }
        }
        while (cursor.next())
    }
    
    function cleanTablature(score)
    {
        var cursor = score.newCursor()

        // If only a segment was selected, only act on that section
        if (cursor.segment)
        {
            cursor.rewind(Cursor.SELECTION_START)
        }
        else
        {
            cursor.rewind(Cursor.SCORE_START)
        }

        do
        {
            if (cursor.element.type == Element.LYRICS)
            {                
                if (addClosingTab) {
                    cursor.add (closingTab)
                }
                
                if (addOpeningTab) {
                    cursor.add (openingTab) 
                }                    
            }
        }
        while (cursor.next())
    }    

    // Debug function
    function elementTypeToString(element)
    {
        switch (element.type)
        {
            case 0:
                return "INVALID"
            case 1:
                return "BRACKET_ITEM"
            case 2:
                return "PART"
            case 3:
                return "STAFF"
            case 4:
                return "SCORE"
            case 5:
                return "SYMBOL"
            case 6:
                return "TEXT"
            case 7:
                return "MEASURE_NUMBER"
            case 8:
                return "INSTRUMENT_NAME"
            case 9:
                return "SLUR_SEGMENT"
            case 10:
                return "TIE_SEGMENT"
            case 11:
                return "BAR_LINE"
            case 12:
                return "STAFF_LINES"
            case 13:
                return "SYSTEM_DIVIDER"
            case 14:
                return "STEM_SLASH"
            case 15:
                return "ARPEGGIO"
            case 16:
                return "ACCIDENTAL"
            case 17:
                return "LEDGER_LINE"
            case 18:
                return "STEM"
            case 19:
                return "NOTE"
            case 20:
                return "CLEF"
            case 21:
                return "KEYSIG"
            case 22:
                return "AMBITUS"
            case 23:
                return "TIMESIG"
            case 24:
                return "REST"
            case 25:
                return "BREATH"
            case 26:
                return "REPEAT_MEASURE"
            case 27:
                return "TIE"
            case 28:
                return "ARTICULATION"
            case 29:
                return "FERMATA"
            case 30:
                return "CHORDLINE"
            case 31:
                return "DYNAMIC"
            case 32:
                return "BEAM"
            case 33:
                return "HOOK"
            case 34:
                return "LYRICS"
            case 35:
                return "FIGURED_BASS"
            case 36:
                return "MARKER"
            case 37:
                return "JUMP"
            case 38:
                return "FINGERING"
            case 39:
                return "TUPLET"
            case 40:
                return "TEMPO_TEXT"
            case 41:
                return "STAFF_TEXT"
            case 42:
                return "SYSTEM_TEXT"
            case 43:
                return "REHEARSAL_MARK"
            case 44:
                return "INSTRUMENT_CHANGE"
            case 45:
                return "STAFFTYPE_CHANGE"
            case 46:
                return "HARMONY"
            case 47:
                return "FRET_DIAGRAM"
            case 48:
                return "BEND"
            case 49:
                return "TREMOLOBAR"
            case 50:
                return "VOLTA"
            case 51:
                return "HAIRPIN_SEGMENT"
            case 52:
                return "OTTAVA_SEGMENT"
            case 53:
                return "TRILL_SEGMENT"
            case 54:
                return "LET_RING_SEGMENT"
            case 55:
                return "VIBRATO_SEGMENT"
            case 56:
                return "PALM_MUTE_SEGMENT"
            case 57:
                return "TEXTLINE_SEGMENT"
            case 58:
                return "VOLTA_SEGMENT"
            case 59:
                return "PEDAL_SEGMENT"
            case 60:
                return "LYRICSLINE_SEGMENT"
            case 61:
                return "GLISSANDO_SEGMENT"
            case 62:
                return "LAYOUT_BREAK"
            case 63:
                return "SPACER"
            case 64:
                return "STAFF_STATE"
            case 65:
                return "NOTEHEAD"
            case 66:
                return "NOTEDOT"
            case 67:
                return "TREMOLO"
            case 68:
                return "IMAGE"
            case 69:
                return "MEASURE"
            case 70:
                return "SELECTION"
            case 71:
                return "LASSO"
            case 72:
                return "SHADOW_NOTE"
            case 73:
                return "TAB_DURATION_SYMBOL"
            case 74:
                return "FSYMBOL"
            case 75:
                return "PAGE"
            case 76:
                return "HAIRPIN"
            case 77:
                return "OTTAVA"
            case 78:
                return "PEDAL"
            case 79:
                return "TRILL"
            case 80:
                return "LET_RING"
            case 81:
                return "VIBRATO"
            case 82:
                return "PALM_MUTE"
            case 83:
                return "TEXTLINE"
            case 84:
                return "TEXTLINE_BASE"
            case 85:
                return "NOTELINE"
            case 86:
                return "LYRICSLINE"
            case 87:
                return "GLISSANDO"
            case 88:
                return "BRACKET"
            case 89:
                return "SEGMENT"
            case 90:
                return "SYSTEM"
            case 91:
                return "COMPOUND"
            case 92:
                return "CHORD"
            case 93:
                return "SLUR"
            case 94:
                return "ELEMENT"
            case 95:
                return "ELEMENT_LIST"
            case 96:
                return "STAFF_LIST"
            case 97:
                return "MEASURE_LIST"
            case 98:
                return "HBOX"
            case 99:
                return "VBOX"
            case 100:
                return "TBOX"
            case 101:
                return "FBOX"
            case 102:
                return "ICON"
            case 103:
                return "OSSIA"
            case 104:
                return "BAGPIPE_EMBELLISHMENT"
            case 105:
                return "STICKING"
            case 106:
                return "MAXTYPE"
            default:
                return "UNKNOWN"
        }

        return "UNKNOWN"
    }

    // Debug function
    function describeObject(obj)
    {
        log (getAllPropertyNames(obj, true, true))
    }

    function getAllPropertyNames(obj, iterateSelfBool, iteratePrototypeBool) {
        var props = [];

        do {
            if (iterateSelfBool) {
                Object.getOwnPropertyNames(obj).forEach(function(prop) {

                    if (props.indexOf(prop) === -1) {
                        props.push(prop);
                    }
                });
            }

            if (!iteratePrototypeBool) {
                break;
            }

            iterateSelfBool = true;
        } while (obj = Object.getPrototypeOf(obj));

        return props;
    }
}
