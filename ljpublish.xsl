<?xml version="1.0"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xt="http://www.jclark.com/xt"
    xmlns="http://www.w3.org/1999/xhtml"
    extension-element-prefixes="xt"
>

<xsl:output
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="DTD/xhtml1-strict.dtd"
    indent="yes"
/>

<xsl:template match="journal">
    <xsl:variable name="journal" select="." />
    <html xml:lang="en" lang="en">
        <head>
            <title>Journal</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <link href="/style.css" rel="stylesheet" type="text/css" />
            <style type="text/css">
                th {
                    text-align: left;
                }
            </style>
        </head>
        <body>
            <div id="navbar">
                <a href="/">hewgill.com</a>
                &#x2192;
                Journal
                <span id="navbar-search"><a href="/search.html">Search</a></span>
            </div>
            <p>
                This is a mirror of <a href="http://ghewgill.livejournal.com">my ghewgill journal</a> which is published and maintained on livejournal.
            </p>
            <p>
                <xsl:call-template name="yearlist">
                    <xsl:with-param name="prefix" select="'calendar/'" />
                </xsl:call-template>
            </p>
            <xsl:call-template name="yearpages">
                <xsl:with-param name="journal" select="$journal" />
            </xsl:call-template>
            <p>
                <xsl:call-template name="taglist">
                    <xsl:with-param name="journal" select="$journal" />
                    <xsl:with-param name="prefix" select="'tags/'" />
                    <xsl:with-param name="curtag" select="'*'" />
                </xsl:call-template>
            </p>
            <xsl:for-each select="document('tags.xml')/tags/tag">
                <xsl:call-template name="tagpage">
                    <xsl:with-param name="journal" select="$journal" />
                    <xsl:with-param name="tag" select="@name" />
                </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="tagpage">
                <xsl:with-param name="journal" select="$journal" />
            </xsl:call-template>
            <table>
                <tr>
                    <th>Date</th>
                    <th>Title</th>
                    <th>Tags</th>
                </tr>
                <xsl:for-each select="event[not(security)]">
                    <xsl:sort select="itemid" data-type="number" order="descending" />
                    <xsl:call-template name="summary" />
                    <xsl:call-template name="entry" />
                </xsl:for-each>
            </table>
            <address>
                Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
            </address>
        </body>
    </html>
</xsl:template>

<xsl:template name="tagpage">
    <xsl:param name="journal" />
    <xsl:param name="tag" />
    <xsl:variable name="tagname">
        <xsl:choose>
            <xsl:when test="$tag"><xsl:value-of select="$tag" /></xsl:when>
            <xsl:otherwise>untagged</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xt:document method="xml" href="tags/{$tagname}.html">
        <html xml:lang="en" lang="en">
            <head>
                <title>Journal</title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <link href="/style.css" rel="stylesheet" type="text/css" />
                <style type="text/css">
                    th {
                        text-align: left;
                    }
                </style>
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="$tagname" />
                    <span id="navbar-search"><a href="/search.html">Search</a></span>
                </div>
                <p>
                    <xsl:call-template name="taglist">
                        <xsl:with-param name="journal" select="$journal" />
                        <xsl:with-param name="curtag" select="$tag" />
                    </xsl:call-template>
                </p>
                <table>
                    <tr>
                        <th>Date</th>
                        <th>Title</th>
                        <th>Tags</th>
                    </tr>
                    <xsl:choose>
                        <xsl:when test="$tag">
                            <xsl:for-each select="itemid">
                                <xsl:sort select="." data-type="number" order="descending" />
                                <xsl:for-each select="$journal/event[not(security)][itemid = current()]">
                                    <xsl:call-template name="summary">
                                        <xsl:with-param name="prefix" select="'../'" />
                                    </xsl:call-template>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="$journal/event[not(security) and not(props/taglist)]">
                                <xsl:sort select="itemid" data-type="number" order="descending" />
                                <xsl:call-template name="summary">
                                    <xsl:with-param name="prefix" select="'../'" />
                                </xsl:call-template>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </table>
                <address>
                    Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
                </address>
            </body>
        </html>
    </xt:document>
</xsl:template>

<xsl:template name="calendarpage">
    <xsl:param name="journal" />
    <xsl:param name="date" />
    <xt:document method="xml" href="calendar/{$date}.html">
        <html xml:lang="en" lang="en">
            <head>
                <title>Journal</title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <link href="/style.css" rel="stylesheet" type="text/css" />
                <style type="text/css">
                    th {
                        text-align: left;
                    }
                </style>
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="$date" />
                    <span id="navbar-search"><a href="/search.html">Search</a></span>
                </div>
                <p>
                    <xsl:call-template name="yearlist" />
                    <br />
                    <a href="{substring($date, 1, 4)}-01.html">Jan</a>
                    <a href="{substring($date, 1, 4)}-02.html">Feb</a>
                    <a href="{substring($date, 1, 4)}-03.html">Mar</a>
                    <a href="{substring($date, 1, 4)}-04.html">Apr</a>
                    <a href="{substring($date, 1, 4)}-05.html">May</a>
                    <a href="{substring($date, 1, 4)}-06.html">Jun</a>
                    <a href="{substring($date, 1, 4)}-07.html">Jul</a>
                    <a href="{substring($date, 1, 4)}-08.html">Aug</a>
                    <a href="{substring($date, 1, 4)}-09.html">Sep</a>
                    <a href="{substring($date, 1, 4)}-10.html">Oct</a>
                    <a href="{substring($date, 1, 4)}-11.html">Nov</a>
                    <a href="{substring($date, 1, 4)}-12.html">Dec</a>
                </p>
                <table>
                    <tr>
                        <th>Date</th>
                        <th>Title</th>
                        <th>Tags</th>
                    </tr>
                    <xsl:for-each select="$journal/event[not(security)][starts-with(eventtime, $date)]">
                        <xsl:sort select="itemid" data-type="number" order="descending" />
                        <xsl:call-template name="summary">
                            <xsl:with-param name="prefix" select="'../'" />
                        </xsl:call-template>
                    </xsl:for-each>
                </table>
                <address>
                    Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
                </address>
            </body>
        </html>
    </xt:document>
</xsl:template>

<xsl:template name="yearlist">
    <xsl:param name="prefix" />
    <xsl:call-template name="yearlist-year">
        <xsl:with-param name="prefix" select="$prefix" />
        <xsl:with-param name="events" select="/journal/event" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="yearlist-year">
    <xsl:param name="prefix" />
    <xsl:param name="events" />
    <xsl:param name="lastyear" />
    <xsl:if test="count($events)">
        <xsl:variable name="year">
            <xsl:value-of select="substring($events[1]/eventtime, 1, 4)" />
        </xsl:variable>
        <xsl:if test="$year != $lastyear">
            <a href="{$prefix}{$year}.html">
                <xsl:value-of select="$year" />
            </a>
        </xsl:if>
        <xsl:call-template name="yearlist-year">
            <xsl:with-param name="prefix" select="$prefix" />
            <xsl:with-param name="events" select="$events[position() != 1]" />
            <xsl:with-param name="lastyear" select="$year" />
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="yearpages">
    <xsl:param name="journal" />
    <xsl:call-template name="yearpages-year">
        <xsl:with-param name="journal" select="$journal" />
        <xsl:with-param name="events" select="/journal/event" />
    </xsl:call-template>
</xsl:template>

<xsl:template name="yearpages-year">
    <xsl:param name="journal" />
    <xsl:param name="events" />
    <xsl:param name="lastyear" />
    <xsl:if test="count($events)">
        <xsl:variable name="year">
            <xsl:value-of select="substring($events[1]/eventtime, 1, 4)" />
        </xsl:variable>
        <xsl:if test="$year != $lastyear">
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="$year" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-01')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-02')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-03')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-04')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-05')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-06')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-07')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-08')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-09')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-10')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-11')" />
            </xsl:call-template>
            <xsl:call-template name="calendarpage">
                <xsl:with-param name="journal" select="$journal" />
                <xsl:with-param name="date" select="concat($year, '-12')" />
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="yearpages-year">
            <xsl:with-param name="journal" select="$journal" />
            <xsl:with-param name="events" select="$events[position() != 1]" />
            <xsl:with-param name="lastyear" select="$year" />
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<xsl:template name="taglist">
    <xsl:param name="journal" />
    <xsl:param name="prefix" />
    <xsl:param name="curtag" />
    <xsl:for-each select="document('tags.xml')/tags/tag">
        <xsl:sort select="@name" />
        <xsl:choose>
            <xsl:when test="@name = $curtag">
                <xsl:value-of select="@name" />
            </xsl:when>
            <xsl:otherwise>
                <a href="{$prefix}{@name}.html">
                    <xsl:value-of select="@name" />
                </a>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="1">, </xsl:if>
    </xsl:for-each>
    <xsl:choose>
        <xsl:when test="not($curtag)">
            [untagged]
        </xsl:when>
        <xsl:otherwise>
            <a href="{$prefix}untagged.html">[untagged]</a>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="summary">
    <xsl:param name="prefix" />
    <tr>
        <td><xsl:value-of select="substring-before(eventtime, ' ')" /></td>
        <td><a href="{$prefix}entries/{itemid}.html"><xsl:value-of select="subject" /></a></td>
        <td><xsl:value-of select="props/taglist" /></td>
    </tr>
</xsl:template>

<xsl:template name="entry">
    <xt:document method="xml" href="entries/{itemid}.html">
        <html>
            <head>
                <title><xsl:value-of select="subject" /></title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <link href="/style.css" rel="stylesheet" type="text/css" />
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="subject" />
                    <span id="navbar-search"><a href="/search.html">Search</a></span>
                </div>
                <!--div>
                    <a href="entries/{preceding-sibling::event[not(security)]/itemid}.html">prev</a>
                    <a href="entries/{following-sibling::event[not(security)]/itemid}.html">next</a>
                </div-->
                <p>
                    Date:
                    <xsl:variable name="year" select="substring-before(eventtime, '-')" />
                    <xsl:variable name="month" select="substring-before(substring-after(eventtime, '-'), '-')" />
                    <a href="../calendar/{$year}.html"><xsl:value-of select="$year" /></a>-<a href="../calendar/{$year}-{$month}.html"><xsl:value-of select="$month" /></a>-<xsl:value-of select="substring-after(substring-after(eventtime, '-'), '-')" /><br />
                    <xsl:if test="props/taglist">
                        Tags:
                        <xsl:call-template name="link-tags">
                            <xsl:with-param name="taglist" select="props/taglist" />
                        </xsl:call-template>
                    </xsl:if>
                </p>
                <div style="font-size: 150%;">
                    <xsl:value-of select="subject" />
                </div>
                <xsl:choose>
                    <xsl:when test="props/opt_preformatted = '1'">
                        <xsl:variable name="body">
                            <xsl:call-template name="lj-tags">
                                <xsl:with-param name="s" select="event" />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$body" disable-output-escaping="yes" />
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

<xsl:template name="link-tags">
    <xsl:param name="taglist" />
    <xsl:variable name="tag">
        <xsl:choose>
            <xsl:when test="contains($taglist, ',')">
                <xsl:value-of select="substring-before($taglist, ',')" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$taglist" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <a href="../tags/{$tag}.html"><xsl:value-of select="$tag" /></a>
    <xsl:variable name="rest" select="substring-after($taglist, ', ')" />
    <xsl:if test="$rest">
        <xsl:if test="$rest">, </xsl:if>
        <xsl:call-template name="link-tags">
            <xsl:with-param name="taglist" select="$rest" />
        </xsl:call-template>
    </xsl:if>
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
            <xsl:choose>
                <xsl:when test="contains(substring-before($rest, '&gt;'), 'user=')">
                    <xsl:variable name="user" select="substring-before(substring-after($rest, 'user=&quot;'), '&quot;')" />
                    &lt;span class="ljuser" style="white-space: nowrap;"&gt;&lt;a href="http://www.livejournal.com/userinfo.bml?user=<xsl:value-of select="$user" />"&gt;&lt;img src="http://stat.livejournal.com/img/userinfo.gif" alt="[info]" width="17" height="17" style="vertical-align: bottom; border: 0;" /&gt;&lt;a href="http://www.livejournal.com/users/<xsl:value-of select="$user" />"&gt;&lt;strong&gt;<xsl:value-of select="$user" />&lt;/strong&gt;&lt;/a&gt;&lt;/span&gt;
                    <xsl:call-template name="lj-tags">
                        <xsl:with-param name="s" select="substring-after($rest, '&gt;')" />
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="lj-tags">
                        <xsl:with-param name="s" select="substring-after($rest, '&gt;')" />
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="$s" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
