<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/GetPersonalDetailsRequest">
    <GetPersonalDetailsRequest>
      <PersonID>
        <xsl:value-of select="PersonID/text()"/>
      </PersonID>
      <DetailsToRetrieve>
        <xsl:for-each select="DetailsToRetrieve/Detail">
          <xsl:element name="{text()}">true</xsl:element>
        </xsl:for-each>
      </DetailsToRetrieve>
    </GetPersonalDetailsRequest>
  </xsl:template>
  <xsl:template match="/GetPersonalDetailsResponse">
    <GetPersonalDetailsResponse>
      <xsl:for-each select="*">
        <xsl:element name="{@type}">
          <xsl:value-of select="text()"/>
        </xsl:element>
      </xsl:for-each>
    </GetPersonalDetailsResponse>
  </xsl:template>
</xsl:stylesheet>
