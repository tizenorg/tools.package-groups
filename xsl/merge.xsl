<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<patterns>
			<xsl:attribute name="count">
				<xsl:value-of select="count(/index/file)"/>
			</xsl:attribute>
			<xsl:for-each select="/index/file">
				<xsl:copy-of select="document(.)"/>
			</xsl:for-each>
		</patterns>
	</xsl:template>
</xsl:stylesheet>
