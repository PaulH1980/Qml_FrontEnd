import QtQuick 2.7
import QtQuick.Controls 2.4
import "Scripts/AppScripts.js" as AppScripts
import "Scripts/FlowScripts.js" as FlowScripts
import "."

TreeViewQc2
{
    id                : tree
    objectName        : "flowTreeView"

    Component.onCompleted:
    {
        createItems()
    }

    function createItems()
    {
        tree.clear()
        FlowScripts.popuplateNodeItemViews( tree, null )
    }
}




