<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
<!ENTITY month "          januar    februar   marts     april     maj       juni      juli      august    september oktober   november  december">
]>
<xsl:stylesheet 
    xmlns:TEI="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    exclude-result-prefixes="#all"
>

<!-- KSR: 2011-063.24 -->
    <xsl:include href="popups.xsl"/>
    
    
    <xsl:template match="TEI:TEI">        
        <div class="mainIntro">
            <div>
                        <xsl:text>Indledning til</xsl:text>
                    </div>
                    <!-- en indledning til flere værker -->
                    <xsl:choose>
                        <xsl:when test="TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:title[@rend='main' or @rend='part']">
                            <xsl:for-each select="//TEI:title[@rend='main' or @rend='part']">
                                <div>
                                    <xsl:choose>
                                        <xsl:when test="@rend='main'">
                                            <i><xsl:value-of select="."/></i>
                                        </xsl:when>
                                        <xsl:when test="@rend='part'">
                                            &#x201C;<xsl:value-of select="."/>&#x201D;
                                        </xsl:when>
                                    </xsl:choose>                                    
                                </div>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                    <div class="author">
                        <xsl:text>ved </xsl:text>
                        <xsl:apply-templates select="TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:author"/>
                    </div>
                </xsl:if>
            </div>
                <xsl:choose>
                    <xsl:when test="//TEI:note[@type='intro']">
                        <xsl:text>Indhold</xsl:text>
                        <xsl:apply-templates mode="toc" select="TEI:text/TEI:body/TEI:div"/>
                        <xsl:apply-templates select="TEI:text"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <div class="head">
                            <xsl:text>er under udarbejdelse</xsl:text>
                        </div>
                    </xsl:otherwise>
                </xsl:choose>
        </div>
        
    </xsl:template>
    
    <xsl:template match="TEI:div" mode="toc">
        <div class="toc" id="retur">
            <a class="toc intro_menu">
                <xsl:attribute name="hrel">
                    <xsl:text>#intro</xsl:text>
                        <xsl:text>_</xsl:text>
                        <xsl:value-of select="replace(base-uri(), '.*?([0-9].*)_intro.xml$', '$1')" />
                        <xsl:text>_</xsl:text>
                        <xsl:number level="multiple" count="TEI:div"/>      
                        <xsl:number level="multiple" count="TEI:div"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="TEI:head"/>
                </xsl:attribute>
            </a>
            <xsl:for-each select="TEI:div">
                <xsl:apply-templates mode="toc" select="."/>
            </xsl:for-each>
        </div>
    </xsl:template> 
    
    <xsl:template match="TEI:head[not(@rend='quote' or @rend='quoteFirst' or @rend='quoteCenter')]">
        <a id="toc">
            <xsl:attribute name="id">
                <xsl:text>intro</xsl:text>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="replace(base-uri(), '.*?([0-9].*)_intro.xml$', '$1')" />
                <xsl:text>_</xsl:text>                
                <xsl:number level="multiple" count="TEI:div"/>
            </xsl:attribute>
        </a>
        <div class="head{@rend}">
             <xsl:attribute name="id">
                <xsl:value-of select="replace(base-uri(), '.*?([0-9].*)_intro.xml$', '$1')" />
                <xsl:text>_intro_</xsl:text>                
                <xsl:value-of select="@xml:id" />
             </xsl:attribute>           
            <a hrel="#retur" class="toc intro_menu">
                <xsl:number level="multiple" count="TEI:div"/>
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
            </a>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:teiHeader/TEI:fileDesc/TEI:titleStmt/TEI:editor[@role='editor']">        
        <div class="editor">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:hi">        
        <span class="{@rend}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="TEI:div">        
        <div class="div">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:fw[@type='longLine']">
        <hr class="fwLongLine"/>        
    </xsl:template>
    
    <xsl:template match="TEI:fw[@type='shortLine']">
        <hr class="fwShortLine"/>
    </xsl:template>
    
    <xsl:template match="TEI:lb">        
        <br>
            <xsl:apply-templates/>
        </br>        
    </xsl:template>

    <xsl:template match="TEI:lg|TEI:l">
        <div class="{name()}">
            <!--xsl:attribute name="class"><xsl:value-of select="name()"/></xsl:attribute-->
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:div[@type='litList']">
        <div class="litList">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:div[@type='webList']">
        <div class="webList">
            <a href="{@target}">
                <xsl:apply-templates/>
            </a>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:list">
        <xsl:if test="@type='decimal'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="decimal">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='upperAlpha'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="upperAlpha">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='lowerAlpha'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="lowerAlpha">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='upperRoman'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="upperRoman">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='lowerRoman'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="lowerRoman">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='simple'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="simple">
                        <xsl:apply-templates/>
                    </li>                
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='ordered'">
            <ul>
                <xsl:for-each select="TEI:item">
                    <li class="ordered">
                        <xsl:apply-templates/>
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
        <xsl:if test="@type='litList'">
            <div class="litList">
                <ul>
                    <xsl:for-each select="TEI:item">
                        <li class="litList">
                            <xsl:apply-templates/>
                            <xsl:text>.</xsl:text>
                        </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="TEI:item[not(@n)]">
        <li class="liOrdered">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="TEI:item[@n]">
        <ul>
            <li class="webList">
                <xsl:text>&lt;</xsl:text>
                <a href="{.}">
                    <xsl:apply-templates/>
                </a>
                <xsl:text>&gt;</xsl:text>
                <xsl:text> (</xsl:text>
                <xsl:number value="substring(@n, 9,2)" format="1"/>
                <xsl:text>. </xsl:text>
                <xsl:value-of select="substring('&month;',substring(@n,6,2)*10+1,9)"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="substring(@n, 1,4)"/>
                <xsl:text>)</xsl:text>
            </li>
        </ul>
    </xsl:template>
    
    <xsl:template match="TEI:note[@type='sic']">
        <span class="sic">
            <xsl:apply-templates/>
            <xsl:text>
                [sic]
            </xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="TEI:note[@type='supp']">
        <span class="supp">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="TEI:note[@type='readMore']"/>    
    
    <xsl:template match="TEI:p[@rend]">
        <div class="{@rend}">
            <xsl:apply-templates/>
            <xsl:if test="following-sibling::*[local-name()='note' and @type='readMore' and position()=1]">
                <span class="app">
                    <xsl:text> </xsl:text>
                    <span class="plus" onclick="showhide(this,'more{generate-id()}')">Læs mere +</span>
                    <div id="more{generate-id()}" class="appInvisible">
                        <div class="readMore">
                            <xsl:apply-templates select="following-sibling::TEI:note[local-name()='note' and @type='readMore' and position()=1]/node()"/>
                        </div>
                    </div>
                </span>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:p">
        <div class="{@rend}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:table">        
        <div class="table">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:row">        
        <div class="row">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="TEI:cell">        
        <span class="cell">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="TEI:ref[@type]">
            <xsl:choose>
                <xsl:when test="@type='web'">
                    <xsl:text>&lt;</xsl:text>
                    <a href="{@target}" target="_blank">
                        <xsl:apply-templates/>
                    </a>
                    <xsl:text>&gt;</xsl:text>
                </xsl:when>
                <xsl:when test="@type='image'">
                    <!--<a href="{@target}">-->
                        <xsl:apply-templates/>
                    <!--</a>-->
                </xsl:when>                                
                <xsl:when test="@type='docIn'">
                    <a class="docIn intro_menu">
                        <xsl:attribute name="href">
                            <xsl:value-of select="replace(base-uri(), '.*?([0-9].*)_intro.xml$', '$1')" />
                            <xsl:text>_</xsl:text>
                            <xsl:value-of select="@target"/>
                        </xsl:attribute>
                    <xsl:apply-templates/>
                    </a>
                </xsl:when>                
                <xsl:when test="@type='docOut'">
                    <span class="docout">
                        <xsl:attribute name="name">
                            <xsl:value-of select="@target"/>
                        </xsl:attribute>           
                        <xsl:apply-templates/>         
                    </span>
                </xsl:when>
            </xsl:choose>   
    </xsl:template>
    
</xsl:stylesheet>
