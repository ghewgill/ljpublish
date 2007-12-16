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
            <link href="style.css" rel="stylesheet" type="text/css" />
        </head>
        <body>
            <div id="navbar">
                <a href="/">hewgill.com</a>
                &#x2192;
                Journal
                <span id="navbar-search"><a href="/search">Search</a></span>
            </div>
            <xsl:call-template name="google-ads" />
            <div id="body">
                <p>
                    This is a mirror of <a href="http://ghewgill.livejournal.com">my ghewgill journal</a> which is published and maintained on livejournal.
                </p>
                <p class="calendar">
                    <xsl:call-template name="yearlist">
                        <xsl:with-param name="prefix" select="'calendar/'" />
                    </xsl:call-template>
                </p>
                <xsl:call-template name="yearpages">
                    <xsl:with-param name="journal" select="$journal" />
                </xsl:call-template>
                <p class="tags">
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
                        <th class="summary-heading">Date</th>
                        <th class="summary-heading">Title</th>
                        <th class="summary-heading">Tags</th>
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
            </div>
            <xsl:comment>#include virtual="/google-analytics.inc"</xsl:comment>
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
                <link href="../style.css" rel="stylesheet" type="text/css" />
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="$tagname" />
                    <span id="navbar-search"><a href="/search">Search</a></span>
                </div>
                <xsl:call-template name="google-ads" />
                <div id="body">
                    <p class="tags">
                        <xsl:call-template name="taglist">
                            <xsl:with-param name="journal" select="$journal" />
                            <xsl:with-param name="curtag" select="$tag" />
                        </xsl:call-template>
                    </p>
                    <table>
                        <tr>
                            <th class="summary-heading">Date</th>
                            <th class="summary-heading">Title</th>
                            <th class="summary-heading">Tags</th>
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
                </div>
                <xsl:comment>#include virtual="/google-analytics.inc"</xsl:comment>
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
                <link href="../style.css" rel="stylesheet" type="text/css" />
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="$date" />
                    <span id="navbar-search"><a href="/search">Search</a></span>
                </div>
                <xsl:call-template name="google-ads" />
                <div id="body">
                    <p class="calendar">
                        <xsl:call-template name="yearlist" />
                        <br />
                        <a href="{substring($date, 1, 4)}-01">Jan</a>
                        <a href="{substring($date, 1, 4)}-02">Feb</a>
                        <a href="{substring($date, 1, 4)}-03">Mar</a>
                        <a href="{substring($date, 1, 4)}-04">Apr</a>
                        <a href="{substring($date, 1, 4)}-05">May</a>
                        <a href="{substring($date, 1, 4)}-06">Jun</a>
                        <a href="{substring($date, 1, 4)}-07">Jul</a>
                        <a href="{substring($date, 1, 4)}-08">Aug</a>
                        <a href="{substring($date, 1, 4)}-09">Sep</a>
                        <a href="{substring($date, 1, 4)}-10">Oct</a>
                        <a href="{substring($date, 1, 4)}-11">Nov</a>
                        <a href="{substring($date, 1, 4)}-12">Dec</a>
                    </p>
                    <table>
                        <tr>
                            <th class="summary-heading">Date</th>
                            <th class="summary-heading">Title</th>
                            <th class="summary-heading">Tags</th>
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
                </div>
                <xsl:comment>#include virtual="/google-analytics.inc"</xsl:comment>
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
            <a href="{$prefix}{$year}">
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
                <a href="{$prefix}{@name}">
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
            <a href="{$prefix}untagged">[untagged]</a>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="urlify">
    <xsl:value-of select="itemid" />-<xsl:value-of select="
        translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(translate(subject,
            'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'),
            '&#x00e0;&#x00e1;&#x00e2;', 'aaa'),
            '&#x0109;', 'c'),
            '&#x00e8;&#x00e9;&#x00ea;', 'eee'),
            '&#x011d;', 'g'),
            '&#x0125;', 'h'),
            '&#x0135;', 'j'),
            '&#x00ec;&#x00ed;&#x00ee;', 'iii'),
            '&#x00fe;&#x00f3;&#x00f4;', 'ooo'),
            '&#x015d;', 's'),
            '&#x00f9;&#x00fa;&#x00fb;&#x016d;', 'uuuu'),
            ' !&quot;#$%&amp;()*+,-./:,&lt;=&gt;?@[\]^_`{|}~', '-')
        " />
</xsl:template>

<xsl:template name="summary">
    <xsl:param name="prefix" />
    <tr>
        <td><xsl:value-of select="substring-before(eventtime, ' ')" /></td>
        <xsl:variable name="linktitle">
            <xsl:call-template name="urlify" />
        </xsl:variable>
        <td><a href="{$prefix}entries/{$linktitle}"><xsl:value-of select="subject" /></a></td>
        <td><xsl:value-of select="props/taglist" /></td>
    </tr>
</xsl:template>

<xsl:template name="entry">
    <xsl:variable name="linktitle">
        <xsl:call-template name="urlify" />
    </xsl:variable>
    <xt:document method="xml" href="entries/{itemid}.html">
        <html>
            <head>
                <meta http-equiv="Refresh" content="0; {$linktitle}" />
            </head>
            <body>
                Moved to <a href="{$linktitle}"><xsl:value-of select="$linktitle" />.html</a>.
            </body>
        </html>
    </xt:document>
    <xt:document method="xml" href="entries/{$linktitle}.html">
        <html>
            <head>
                <title><xsl:value-of select="subject" /></title>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                <link href="/style.css" rel="stylesheet" type="text/css" />
                <link href="../style.css" rel="stylesheet" type="text/css" />
            </head>
            <body>
                <div id="navbar">
                    <a href="/">hewgill.com</a>
                    &#x2192;
                    <a href="/journal/">Journal</a>
                    &#x2192;
                    <xsl:value-of select="subject" />
                    <span id="navbar-search"><a href="/search">Search</a></span>
                </div>
                <xsl:call-template name="google-ads" />
                <div id="body">
                    <!--div>
                        <a href="entries/{preceding-sibling::event[not(security)]/itemid}">prev</a>
                        <a href="entries/{following-sibling::event[not(security)]/itemid}">next</a>
                    </div-->
                    <div class="entry-header">
                        Date:
                        <xsl:variable name="year" select="substring-before(eventtime, '-')" />
                        <xsl:variable name="month" select="substring-before(substring-after(eventtime, '-'), '-')" />
                        <a href="../calendar/{$year}"><xsl:value-of select="$year" /></a>-<a href="../calendar/{$year}-{$month}"><xsl:value-of select="$month" /></a>-<xsl:value-of select="substring-after(substring-after(eventtime, '-'), '-')" /><br />
                        <xsl:if test="props/taglist">
                            Tags:
                            <xsl:call-template name="link-tags">
                                <xsl:with-param name="taglist" select="props/taglist" />
                            </xsl:call-template>
                        </xsl:if>
                    </div>
                    <div class="entry-userpic">
                        <xsl:choose>
                            <xsl:when test="props/picture_keyword">
                                <img src="{/journal/userpics/userpic[@keyword=current()/props/picture_keyword]/@url}" />
                            </xsl:when>
                            <xsl:otherwise>
                                <img src="{/journal/userpics/userpic[@keyword='*']/@url}" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="entry-subject">
                        <xsl:value-of select="subject" />
                    </div>
                    <xsl:choose>
                        <xsl:when test="props/opt_preformatted = '1'">
                            <xsl:variable name="body">
                                <xsl:call-template name="lj-tags">
                                    <xsl:with-param name="s" select="event" />
                                </xsl:call-template>
                            </xsl:variable>
                            <div class="entry-body">
                                <xsl:value-of select="$body" disable-output-escaping="yes" />
                            </div>
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
                            <div class="entry-body">
                                <xsl:value-of select="$body" disable-output-escaping="yes" />
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                    <p class="lj-link">
                        <a href="{url}">Link</a>
                    </p>
                    <xsl:if test="not(props/opt_nocomments) or props/opt_nocomments != '1'">
                        <xsl:for-each select="comments/comment[string-length(parentid)=0]">
                            <xsl:call-template name="comment">
                                <xsl:with-param name="indent" select="0" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                    <address>
                        Greg Hewgill <a href="mailto:greg@hewgill.com">&lt;greg@hewgill.com&gt;</a>
                    </address>
                </div>
                <xsl:comment>#include virtual="/google-analytics.inc"</xsl:comment>
            </body>
        </html>
    </xt:document>
</xsl:template>

<xsl:template name="comment">
    <xsl:param name="indent" />
    <xsl:if test="string-length(body) and (not(state) or state = '' or state = 'A')">
        <div class="comment" style="margin-left: {$indent*2}em">
            <div class="comment-header">
                <xsl:choose>
                    <xsl:when test="user">
                        <xsl:variable name="user">
                            <xsl:call-template name="lj-tags">
                                <xsl:with-param name="s">&lt;lj user=&quot;<xsl:value-of select="user" />&quot; /&gt;</xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="$user" disable-output-escaping="yes" />
                    </xsl:when>
                    <xsl:otherwise>
                        (anonymous)
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="string-length(subject)">: <xsl:value-of select="subject" /></xsl:if>
                <br />
                <xsl:value-of select="date" />
            </div>
            <xsl:variable name="body">
                <xsl:call-template name="format">
                    <xsl:with-param name="s" select="body" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="body">
                <xsl:call-template name="lj-tags">
                    <xsl:with-param name="s" select="$body" />
                </xsl:call-template>
            </xsl:variable>
            <div class="comment-body">
                <xsl:value-of select="$body" disable-output-escaping="yes" />
            </div>
        </div>
    </xsl:if>
    <xsl:for-each select="../comment[parentid=current()/id]">
        <xsl:call-template name="comment">
            <xsl:with-param name="indent" select="$indent+1" />
        </xsl:call-template>
    </xsl:for-each>
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
    <a href="../tags/{$tag}"><xsl:value-of select="$tag" /></a>
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

<xsl:template name="google-ads">
    <div id="ad">
        <script type="text/javascript"><xsl:comment>
        google_ad_client = "pub-5805981147274775";
        //120x600, created 12/15/07, journal
        google_ad_slot = "9836732755";
        google_ad_width = 120;
        google_ad_height = 600;
        //</xsl:comment></script>
        <script type="text/javascript"
        src="http://pagead2.googlesyndication.com/pagead/show_ads.js" xml:space="preserve">
        </script>
    </div>
</xsl:template>

</xsl:stylesheet>
