<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/GetPersonalDetailsRequest">
    <GetPersonalDetailsRequest>
      <PersonID>
        <xsl:value-of select="PersonID/text()"/>
      </PersonID>
      <DetailsToRetrieve>
        <xsl:for-each select="DetailsToRetrieve/*">
          <Detail>
            <xsl:value-of select="local-name()"/>
          </Detail>
        </xsl:for-each>
      </DetailsToRetrieve>
    </GetPersonalDetailsRequest>
  </xsl:template>
  <xsl:template match="/GetPersonalDetailsResponse">
    <GetPersonalDetailsResponse>
      <xsl:for-each select="*">
        <PersonalDetail>
          <xsl:attribute name="type">
            <xsl:value-of select="local-name()"/>
          </xsl:attribute>
          <xsl:value-of select="text()"/>
        </PersonalDetail>
      </xsl:for-each>
    </GetPersonalDetailsResponse>
  </xsl:template>
</xsl:stylesheet>