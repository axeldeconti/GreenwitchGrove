class TutoText 
{
    public static var texts : Map<Int, String> = 
    [
        1 => '<p>Parfois, il suffit de me laisser pousser.</p><p>Mais si je fléchis, il me faut de l’<font color="#4a6ca9">eau</font>.</p>',
        2 => '<p>Je pousse naturellement vers le haut.</p><p>Mais je peux aller sur le côté</p><p>si on fait appel à l’<font color="#baa42e">air</font>.</p>',
        3 => '<p>Si le vent ne souffle pas dans la bonne <font color="#baa42e">direction</font>,</p><p>il est possible de la <font color="#baa42e">changer</font> grâce au <font color="#baa42e">ruban</font>.</p>',
        4 => '<p>Si vous n’avez pas le temps de me voir pousser à</p><p>mon rythme, alors la <font color="#597d33">terre</font> me fera accélérer.</p>',
        5 => '<p>Parfois, je fais fausse route.</p><p>Le <font color="#ad2727">feu</font> peut être une solution.</p>',
        8 => 'Avec le <font color="#ad2727">feu</font>, je fléchis aussi plus vite.'
    ];

    public static var controlText : String = '<p><b>1.</b> Vous ne pouvez jouer que pendant le jour.</p>
    <p>2. Utiliser les éléments :</p><p>- L’<font color="#4a6ca9">eau</font> fait pousser la plante vers le haut.</p><p>Sans <font color="#4a6ca9">eau</font>, elle finit par fléchir.</p><p>- L’<font color="#baa42e">air</font> modifie la direction de la plante. Le vent</p><p>peut la porter vers la droite ou vers la gauche.</p><p>- La <font color="#597d33">terre</font> permet à la plante de pousser deux</p><p>fois plus vite.</p><p>- Le <font color="#ad2727">feu</font> annule la dernière action et fait reculer</p><p>la plante.</p><p>- <font color="#647782">CANC</font> vous permet d’annuler une action si vous</p><p>préférez ne rien faire.</p>
    <p>3. Si vous voulez changer la direction du vent,</p><p>vous pouvez utiliser le <font color="#baa42e">ruban jaune</font>.</p><p>La flèche indiquera la direction actuelle.</p><p>Quand plus rien ne va, le <font color="#647782">ruban gris</font> vous permet-</p><p>-tra de recommencer le niveau.</p>';
}