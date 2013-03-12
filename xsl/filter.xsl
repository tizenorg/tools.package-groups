<?xml version="1.0" ?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:rpm="http://linux.duke.edu/metadata/rpm"
    xmlns:patterns="http://novell.com/package/metadata/suse/pattern"
    xmlns="http://novell.com/package/metadata/suse/pattern"
    version="1.0">

    <xsl:output method="xml" indent="yes" name="xml"/>
    <xsl:param name="arch"/>

    <xsl:template match="/">
        <pattern>
            <xsl:apply-templates/>
        </pattern>
    </xsl:template>

    <xsl:template match="*">
        <name><xsl:value-of select="patterns:name"/></name>
        <summary><xsl:value-of select="patterns:summary"/></summary>
        <description><xsl:value-of select="patterns:description"/></description>
        <uservisible/>
        <category lang="en"><xsl:value-of select="patterns:category"/></category>
        <rpm:requires>
            <xsl:for-each select="rpm:requires/rpm:entry">
                <xsl:if test="@arch = $arch or not(@arch)">
                    <rpm:entry>
                        <xsl:attribute name="name">
                                <xsl:value-of select="@name"/>
                        </xsl:attribute>
                    </rpm:entry>
               </xsl:if>
            </xsl:for-each>
        </rpm:requires>
    </xsl:template>


</xsl:stylesheet>
