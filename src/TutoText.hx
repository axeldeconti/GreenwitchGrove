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

    public static var controlText : String = '<p>1. Vous ne pouvez jouer que pendant le jour.</p>
    <p>2. Pour faire pousser la plante, il faut faire appel aux éléments :</p>
    <p>- L’<font color="#4a6ca9">eau</font> vous permet de la faire pousser vers le haut.</p>
    <p>Après quelques jours sans <font color="#4a6ca9">eau</font>, la plante commencera à fléchir.</p>
    <p>- L’<font color="#baa42e">air</font> modifie la direction de la plante. Le vent peut la porter</p><p>vers la droite ou vers la gauche.</p>
    <p>- La <font color="#597d33">terre</font> permet à la plante de pousser deux fois plus vite.</p><p>Mais elle s’épuise tout autant, pensez donc à l’<font color="#4a6ca9">eau</font> !</p>
    <p>- Le <font color="#ad2727">feu</font> annule la dernière action et fait reculer la plante.</p><p>Mais elle sera aussi desséchée et fléchira si vous la laissez sans <font color="#4a6ca9">eau</font>.</p>
    <p>- <font color="#647782">CANC</font> vous permet d’annuler une action si vous préférez ne rien faire.</p>
    <p>3. Si vous voulez changer la direction du vent, vous pouvez utiliser le <font color="#baa42e">ruban jaune</font>.</p><p>La flèche indiquera la direction actuelle.</p>
    <p>Quand plus rien ne va, le <font color="#647782">ruban gris</font> vous permettra de recommencer le niveau.</p>';
}