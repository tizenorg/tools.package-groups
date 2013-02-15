<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rpm="http://linux.duke.edu/metadata/rpm"
    xmlns:patterns="http://novell.com/package/metadata/suse/pattern"
    version="1.0">

    <xsl:output method="xml" indent="yes" name="xml"/>

    <xsl:template match="patterns">
        <comps>
            <xsl:for-each select="patterns:pattern">
                <group>
                    <id><xsl:value-of select="patterns:name"/></id>
                    <name><xsl:value-of select="patterns:summary"/></name>
                    <description><xsl:value-of select="patterns:description"/></description>
                    <uservisible>true</uservisible>
                    <packagelist>
                        <xsl:for-each select="rpm:requires/rpm:entry">
                            <packagereq type="default"><xsl:value-of select="@name"/></packagereq>
                        </xsl:for-each>
                    </packagelist>
                </group>
            </xsl:for-each>
        </comps>
    </xsl:template>


</xsl:stylesheet>
