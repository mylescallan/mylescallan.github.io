// ae_prompt function sources 
var ae_cb = null;
function ae$(a) { return document.getElementById(a); } 
function ae_prompt(cb, q, a) {
ae_cb = cb;
ae$('aep_t').innerHTML = document.domain + ' question:';
ae$('aep_prompt').innerHTML = q;
ae$('aep_text').value = a; 
ae$('aep_ovrl').style.display = ae$('aep_ww').style.display = ''; 
ae$('aep_text').focus(); 
ae$('aep_text').select(); 
}
function ae_clk(m) { 
ae$('aep_ovrl').style.display = ae$('aep_ww').style.display = 'none'; 
if (!m) ae_cb(null); else ae_cb(ae$('aep_text').value);
}
// ae_prompt function sources 

