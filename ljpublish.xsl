<?xml version="1.0"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xt="http://www.jclark.com/xt"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="xt"
>

<xsl:output indent="yes" />

<xsl:template match="journal">
    <html xml:lang="en" lang="en">
        <head>
            <title>Journal</title>
            <link href="/style.css" rel="stylesheet" type="text/css" />
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        </head>
        <body>
            <div id="navbar">
                <a href="/">hewgill.com</a>
                <img src="/images/arrow.png" height="5" width="10" alt="-&gt;" />
                <a href="/journal/">Journal</a>
                <span id="navbar-search"><a href="/search.html">Search</a></span>
            </div>
            <p>
                This is a mirror of <a href="http://ghewgill.livejournal.com">my ghewgill journal</a> which is published and maintained on livejournal.
            </p>
            <ul>
                <xsl:for-each select="event[not(security)]">
                    <xsl:sort select="itemid" data-type="number" order="descending" />
                    <li xml:space="preserve"><xsl:value-of select="substring-before(eventtime, ' ')" /> <a href="{itemid}.html"><xsl:value-of select="subject" /></a></li>
                    <xsl:call-template name="entry" />
                </xsl:for-each>
            </ul>
            <address>
                Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
            </address>
        </body>
    </html>
</xsl:template>

<xsl:template name="entry">
    <xt:document method="xml" href="{itemid}.html">
        <html>
            <head>
                <title><xsl:value-of select="subject" /></title>
                <link href="/style.css" rel="stylesheet" type="text/css" />
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    <img src="/images/arrow.png" height="5" width="10" alt="-&gt;" />
                    <a href="/journal/">Journal</a>
                    <img src="/images/arrow.png" height="5" width="10" alt="-&gt;" />
                    <xsl:value-of select="subject" />
                    <span id="navbar-search"><a href="/search.html">Search</a></span>
                </div>
                <!--div>
                    <a href="{preceding-sibling::event[not(security)]/itemid}.html">prev</a>
                    <a href="{following-sibling::event[not(security)]/itemid}.html">next</a>
                </div-->
                <p>
                    Date: <xsl:value-of select="eventtime" /><br />
                </p>
                <div style="font-size: 150%;">
                    <xsl:value-of select="subject" />
                </div>
                <xsl:choose>
                    <xsl:when test="props/opt_preformatted = '1'">
                        <xsl:value-of select="event" disable-output-escaping="yes" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="body">
                            <xsl:call-template name="format">
                                <xsl:with-param name="s" select="event" />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="body">
                            <xsl:call-template name="lj-tags">
                                <xsl:with-param name="s" select="$body" />
                            </xsl:call-template>
                        </xsl:variable>
                        <p>
                            <xsl:value-of select="$body" disable-output-escaping="yes" />
                        </p>
                    </xsl:otherwise>
                </xsl:choose>
                <p>
                    <a href="{url}">Link</a>
                </p>
                <address>
                    Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
                </address>
            </body>
        </html>
    </xt:document>
</xsl:template>

<xsl:template name="format">
    <xsl:param name="s" />
    <xsl:choose>
        <xsl:when test="contains($s, '&#10;')">
            <xsl:value-of select="substring-before($s, '&#10;')" />
            &lt;br /&gt;
            <xsl:call-template name="format">
                <xsl:with-param name="s" select="substring-after($s, '&#10;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$s" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="lj-tags">
    <xsl:param name="s" />
    <xsl:choose>
        <xsl:when test="contains($s, '&lt;lj')">
            <xsl:value-of select="substring-before($s, '&lt;lj')" />
            <xsl:variable name="rest" select="substring-after($s, '&lt;lj')" />
            <xsl:variable name="user" select="substring-before(substring-after($rest, 'user=&quot;'), '&quot;')" />
            &lt;span class="ljuser" style="white-space: nowrap;"&gt;&lt;a href="http://www.livejournal.com/userinfo.bml?user=<xsl:value-of select="$user" />"&gt;&lt;img src="http://stat.livejournal.com/img/userinfo.gif" alt="[info]" width="17" height="17" style="vertical-align: bottom; border: 0;" /&gt;&lt;a href="http://www.livejournal.com/users/<xsl:value-of select="$user" />"&gt;&lt;strong&gt;<xsl:value-of select="$user" />&lt;/strong&gt;&lt;/a&gt;&lt;/span&gt;
            <xsl:call-template name="lj-tags">
                <xsl:with-param name="s" select="substring-after($rest, '&gt;')" />
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$s" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
