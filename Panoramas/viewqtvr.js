// viewqtvr.js - embed a quicktime VR movie in a webpage
// freely distributable
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL NORMAN WALSH OR ANY OTHER CONTRIBUTOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

function makeQTObject(moviefile,width,height)
{
  document.write("<object classid=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" codebase=\"http://www.apple.com/qtactivex/qtplugin.cab\" height=\""+height+"\" width=\""+width+"\">");
  document.write("<param name=\"src\" value=\""+escape(moviefile)+"\">");
  document.write("<embed height=\""+height+"\" width=\""+width+"\" src=\""+escape(moviefile)+"\" pluginspage=\"http://www.apple.com/quicktime/download/\" type=\"video/quicktime\" />");
  document.write("</object>");
}
