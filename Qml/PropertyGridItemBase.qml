import QtQuick 2.7
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import "."


Rectangle
{
    /*
        @brief: Signal json object changed, these eventually should contain
                everything above.
    */
    signal                          jsonObjectChanged( var jsonObject )
    signal                          propertyChanged( var value )


    property int mRoleType          : -1                            //inspector roles see ObjectPropertyModel.cpp
    property int mIndexOf           : -1					        //index of items, c++ side
    property int mPropHeight        : 24					        //default height for propgrid items
    property int mPropValueFontSize : 16
    property int mAnchorsLeftMargin : 32
    property int mNestedDepth       : 0
    
    property int mObjId             : 2147483645 			        //invalid objId
    property string mDescription    : "PlaceHolder:" 				//title place holder

    //property as json object, currently only used for comboxbox/enum property
    //TODO all PropertyGridItems should be constructed from this
    property var    mJsonObj           : ({}) //shared property data
    property var    propertyDataJson   : ({}) //filled after 'updateItem' contains 'value'


    id								: propGridItemId
    color				   			: Style.defaultBackGroundColor
    height							: mPropHeight

    function sectionClicked( name, expanded )
    {
        if( mJsonObj.SectionName === name ) //only for this section name
            visible = expanded      
    }


    //needed for collapsible property grid items
    function getHeight()
    {
        return visible ? propGridItemId.mPropHeight : 0
    }

    function getXLabel()
    {
        return mJsonObj.Label_X !== undefined ? mJsonObj.Label_X : "X"
    }

    function getYLabel()
    {
        return mJsonObj.Label_Y !== undefined ? mJsonObj.Label_Y : "Y"
    }

    function getZLabel()
    {
        return mJsonObj.Label_Z !== undefined ? mJsonObj.Label_Z : "Z"
    }

    function getWLabel()
    {
        return mJsonObj.Label_W !== undefined ? mJsonObj.Label_W : "W"
    }

    function getDescription()
    {
        return mDescription;
    }
}
